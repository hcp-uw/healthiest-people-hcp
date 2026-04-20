/**
 * Posts — creation callable.
 *
 * The client uploads the video + thumbnail directly to Storage, then calls
 * `createPostFromSession` with the session ID and the two Storage URLs.
 *
 * Doing this server-side lets us:
 *   - verify the session actually belongs to the caller
 *   - copy the (clamped/verified) duration from the session so a 30-second
 *     clip can't masquerade as an 8-hour study post
 *   - denormalize authorName / authorPhotoURL onto the post so the feed
 *     doesn't have to join against users/ on every read
 *   - bump `users.postCount` atomically
 *   - link the session back to the post so a user can see which session
 *     produced which post
 *
 * The post document's field names match Post.swift exactly (id, authorId,
 * authorName, authorPhotoURL, videoURL, thumbnailURL, caption, createdAt).
 * A few server-maintained fields (sessionId, durationMinutes, reactionCount,
 * commentCount) live alongside them — the iOS Codable decoder ignores
 * anything it doesn't declare.
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

interface CreatePostInput {
  sessionId: string;
  videoURL: string;
  thumbnailURL: string;
  caption?: string;
}

const MAX_CAPTION = 280;

export const createPostFromSession = onCall<CreatePostInput>(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Must be signed in.");

  const { sessionId, videoURL, thumbnailURL, caption } = request.data ?? {};
  if (!sessionId || !videoURL || !thumbnailURL) {
    throw new HttpsError(
      "invalid-argument",
      "sessionId, videoURL, and thumbnailURL are required.",
    );
  }
  if ((caption?.length ?? 0) > MAX_CAPTION) {
    throw new HttpsError(
      "invalid-argument",
      `Caption must be ${MAX_CAPTION} characters or fewer.`,
    );
  }

  const db = getFirestore();
  const sessionRef = db.doc(`sessions/${sessionId}`);
  const userRef = db.doc(`users/${uid}`);
  const postRef = db.collection("posts").doc();

  const postId = await db.runTransaction(async (tx) => {
    const [sessionSnap, userSnap] = await Promise.all([
      tx.get(sessionRef),
      tx.get(userRef),
    ]);

    if (!sessionSnap.exists) {
      throw new HttpsError("not-found", "Session not found.");
    }
    if (sessionSnap.get("userId") !== uid) {
      throw new HttpsError("permission-denied", "Not your session.");
    }
    if (sessionSnap.get("postId")) {
      throw new HttpsError("already-exists", "Session already has a post.");
    }

    const verifiedDuration =
      (sessionSnap.get("verifiedDurationMinutes") as number | undefined) ?? 0;
    if (verifiedDuration <= 0) {
      throw new HttpsError(
        "failed-precondition",
        "Session has not been scored yet; retry in a moment.",
      );
    }

    tx.set(postRef, {
      // --- iOS-visible fields (Post.swift) ---
      authorId: uid,
      authorName: userSnap.get("displayName") ?? "",
      authorPhotoURL: userSnap.get("photoURL") ?? null,
      videoURL,
      thumbnailURL,
      caption: caption ?? "",
      createdAt: FieldValue.serverTimestamp(),

      // --- server-maintained fields (iOS decoder ignores unknowns) ---
      sessionId,
      durationMinutes: verifiedDuration,
      reactionCount: 0,
      commentCount: 0,
    });

    tx.update(sessionRef, { postId: postRef.id });
    tx.update(userRef, {
      postCount: FieldValue.increment(1),
      updatedAt: FieldValue.serverTimestamp(),
    });

    return postRef.id;
  });

  logger.info("Post created", { uid, postId, sessionId });
  return { postId };
});

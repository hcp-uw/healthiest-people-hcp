/**
 * User-lifecycle triggers + callables.
 *
 *   onUserCreated    — Auth trigger. Seeds users/{uid} on first sign-in.
 *   onUserDocDelete  — Firestore trigger. Releases the user's reserved username.
 *   claimUsername    — HTTPS callable. Reserves a unique username transactionally.
 *
 * Field naming matches LockDUser.swift (id, displayName, photoURL, xp,
 * currentStreak, timesLockedIn, minutesPerWeek, lastActiveAt,
 * previousWeekPoints, createdAt, updatedAt). A few server-internal fields
 * (longestStreak, lastStudyDay, postCount) are seeded too — the iOS Codable
 * decoder simply ignores any extras.
 */

import { auth } from "firebase-functions/v1";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

const USERNAME_RE = /^[a-z0-9_]{3,20}$/;

// NOTE: Auth triggers are still v1 only — Firebase has not shipped a v2 Auth
// trigger as of firebase-functions v5. This is the current recommended pattern.
export const onUserCreated = auth.user().onCreate(async (user) => {
  const db = getFirestore();
  const ref = db.doc(`users/${user.uid}`);

  await ref.set(
    {
      // --- iOS-visible fields (LockDUser.swift) ---
      displayName: user.displayName ?? "",
      photoURL: user.photoURL ?? null,
      xp: 0,
      currentStreak: 0,
      timesLockedIn: 0,
      minutesPerWeek: 0,
      lastActiveAt: FieldValue.serverTimestamp(),
      previousWeekPoints: 0,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),

      // --- server-internal fields (iOS decoder ignores unknowns) ---
      longestStreak: 0,
      lastStudyDay: null,
      postCount: 0,
    },
    { merge: true },
  );

  logger.info("Seeded user doc", { uid: user.uid });
});

export const onUserDocDelete = onDocumentDeleted("users/{uid}", async (event) => {
  const data = event.data?.data();
  const username = data?.username as string | undefined;
  if (!username) return;

  const db = getFirestore();
  await db
    .doc(`usernames/${username.toLowerCase()}`)
    .delete()
    .catch(() => {
      /* best-effort */
    });
});

/**
 * Reserves a unique username for the caller and writes it onto their user doc.
 * Runs in a transaction so two users can't race for the same name.
 *
 * Call from iOS:
 *   Functions.functions().httpsCallable("claimUsername").call(["joylockd"])
 */
export const claimUsername = onCall<{ username: string }>(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Must be signed in.");

  const raw = (request.data?.username ?? "").trim().toLowerCase();
  if (!USERNAME_RE.test(raw)) {
    throw new HttpsError(
      "invalid-argument",
      "Username must be 3–20 chars: lowercase letters, numbers, or underscore.",
    );
  }

  const db = getFirestore();
  const nameRef = db.doc(`usernames/${raw}`);
  const userRef = db.doc(`users/${uid}`);

  await db.runTransaction(async (tx) => {
    const existing = await tx.get(nameRef);
    if (existing.exists && existing.get("uid") !== uid) {
      throw new HttpsError("already-exists", "Username is taken.");
    }

    const userSnap = await tx.get(userRef);
    const previous = userSnap.get("username") as string | undefined;
    if (previous && previous !== raw) {
      tx.delete(db.doc(`usernames/${previous}`));
    }

    tx.set(nameRef, { uid });
    tx.set(
      userRef,
      { username: raw, updatedAt: FieldValue.serverTimestamp() },
      { merge: true },
    );
  });

  return { username: raw };
});

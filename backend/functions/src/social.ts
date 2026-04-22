/**
 * Comment / reaction counter triggers + post cascade delete.
 *
 *   onCommentCreated / onCommentDeleted — keep posts.commentCount in sync
 *   onReactionWritten                   — keeps posts.reactionCount in sync
 *   onPostDeleted                       — cleans up every comment, every
 *                                         reaction, and decrements the
 *                                         author's postCount when a post
 *                                         is removed
 *
 * Each counter update() is guarded against NOT_FOUND: if the parent post
 * was deleted between the child write and the trigger firing, we just log
 * and return instead of letting Firebase retry until the budget is burned.
 *
 * IMPORTANT: onPostDeleted deletes comments + reactions in pages of 400.
 * If a post has > 400 of either, the trigger loops until the collection
 * is empty.
 */

import {
  onDocumentCreated,
  onDocumentDeleted,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

/** gRPC status code 5 = NOT_FOUND (Firestore surfaces this when update() */
/* hits a non-existent doc). */
const GRPC_NOT_FOUND = 5;
const DELETE_PAGE_SIZE = 400;

async function bumpPostCounter(postId: string, field: string, delta: number) {
  try {
    await getFirestore()
      .doc(`posts/${postId}`)
      .update({ [field]: FieldValue.increment(delta) });
  } catch (err: unknown) {
    const code = (err as { code?: number }).code;
    if (code === GRPC_NOT_FOUND) {
      logger.info("Skipping counter update; parent post gone", {
        postId,
        field,
        delta,
      });
      return;
    }
    throw err;
  }
}

export const onCommentCreated = onDocumentCreated(
  "posts/{postId}/comments/{commentId}",
  async (event) => bumpPostCounter(event.params.postId, "commentCount", 1),
);

export const onCommentDeleted = onDocumentDeleted(
  "posts/{postId}/comments/{commentId}",
  async (event) => bumpPostCounter(event.params.postId, "commentCount", -1),
);

/**
 * Reactions use doc-per-user, so we increment on create, decrement on delete,
 * and do nothing on update (the user is just switching reaction types).
 */
export const onReactionWritten = onDocumentWritten(
  "posts/{postId}/reactions/{uid}",
  async (event) => {
    const before = event.data?.before.exists;
    const after = event.data?.after.exists;
    if (before === after) return; // update — count unchanged

    const delta = after ? 1 : -1;
    await bumpPostCounter(event.params.postId, "reactionCount", delta);
  },
);

/**
 * Cleans up after a post is deleted:
 *   - deletes every document in posts/{postId}/comments
 *   - deletes every document in posts/{postId}/reactions
 *   - decrements users/{authorId}.postCount so the profile stays accurate
 *
 * The counter triggers above will ALSO fire for each deleted comment/reaction,
 * but they'll hit NOT_FOUND on the parent post and short-circuit. That's fine.
 */
export const onPostDeleted = onDocumentDeleted(
  "posts/{postId}",
  async (event) => {
    const db = getFirestore();
    const postId = event.params.postId;
    const authorId = event.data?.get("authorId") as string | undefined;

    // Delete subcollections in pages.
    await deleteCollection(db, `posts/${postId}/comments`);
    await deleteCollection(db, `posts/${postId}/reactions`);

    // Decrement author postCount. Best-effort: if the user doc is gone
    // (account deletion), skip silently.
    if (authorId) {
      try {
        await db.doc(`users/${authorId}`).update({
          postCount: FieldValue.increment(-1),
          updatedAt: FieldValue.serverTimestamp(),
        });
      } catch (err: unknown) {
        const code = (err as { code?: number }).code;
        if (code !== GRPC_NOT_FOUND) throw err;
      }
    }

    logger.info("Post cascade cleanup complete", { postId, authorId });
  },
);

/** Deletes every document in a (shallow) collection in batches. */
async function deleteCollection(
  db: FirebaseFirestore.Firestore,
  path: string,
) {
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const page = await db.collection(path).limit(DELETE_PAGE_SIZE).get();
    if (page.empty) return;
    const batch = db.batch();
    page.docs.forEach((d) => batch.delete(d.ref));
    await batch.commit();
    if (page.size < DELETE_PAGE_SIZE) return;
  }
}

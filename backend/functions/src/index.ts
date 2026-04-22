/**
 * LOCKD Cloud Functions — entry point.
 *
 * Keep this file thin: just re-export triggers grouped by feature.
 * Firebase discovers every exported function by scanning this module.
 */

import { initializeApp } from "firebase-admin/app";

initializeApp();

// users
export { onUserCreated, onUserDocDelete, claimUsername } from "./users";

// study sessions → XP + streaks
export { onSessionCreated } from "./sessions";

// posts
export { createPostFromSession } from "./posts";

// comments + reactions counters + post cascade delete
export {
  onCommentCreated,
  onCommentDeleted,
  onReactionWritten,
  onPostDeleted,
} from "./social";

// leaderboards (scheduled)
export {
  refreshLeaderboards,
  rolloverWeeklyStats,
  gcOldWeeklySnapshots,
} from "./leaderboards";

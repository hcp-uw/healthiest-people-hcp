/**
 * Study-session trigger.
 *
 * When the client creates a session doc with userId + durationMinutes, this
 * trigger awards XP, bumps counters, and updates the user's streak.
 *
 * XP formula matches iOS `StudySession.xpEarned`: 1 XP per minute.
 * Each session is capped at `MAX_SESSION_MINUTES` to prevent abuse (stale
 * recording left running overnight, or a bad client sending a huge value).
 *
 * NOTE on "verification": the iOS StudySession model only carries
 * `durationMinutes` — there are no server-visible startedAt/endedAt timestamps.
 * So we trust the client's duration, but we clamp it. If we ever add true
 * start/end timestamps on the client, this trigger can compute the verified
 * duration and overwrite durationMinutes before awarding XP.
 */

import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

const MAX_SESSION_MINUTES = 8 * 60; // 8 hours
const MS_PER_DAY = 1000 * 60 * 60 * 24;

export const onSessionCreated = onDocumentCreated(
  "sessions/{sessionId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const userId = data.userId as string | undefined;
    const rawDuration = data.durationMinutes as number | undefined;
    const createdAt = (data.createdAt as Timestamp | undefined) ?? Timestamp.now();

    if (!userId || typeof rawDuration !== "number" || rawDuration <= 0) {
      logger.warn("Malformed session; skipping", { sessionId: snap.id, data });
      return;
    }

    // Clamp the client-provided duration to a sane range.
    const minutes = Math.min(Math.floor(rawDuration), MAX_SESSION_MINUTES);
    const xp = minutes; // 1 XP per minute — matches iOS xpEarned.

    const db = getFirestore();
    const userRef = db.doc(`users/${userId}`);

    await db.runTransaction(async (tx) => {
      const userSnap = await tx.get(userRef);
      const user = userSnap.data() ?? {};

      // --- streak logic (UTC-day based) ---
      const today = startOfUTCDay(createdAt.toDate());
      const lastActive = user.lastStudyDay as Timestamp | undefined;
      let currentStreak: number = user.currentStreak ?? 0;
      const longestStreak: number = user.longestStreak ?? 0;

      if (!lastActive) {
        currentStreak = 1;
      } else {
        const lastDay = startOfUTCDay(lastActive.toDate());
        const daysDiff = Math.round(
          (today.getTime() - lastDay.getTime()) / MS_PER_DAY,
        );
        if (daysDiff === 0) {
          // same UTC day — streak already counted
        } else if (daysDiff === 1) {
          currentStreak += 1;
        } else {
          currentStreak = 1; // streak broken, restart today
        }
      }

      // Record the awarded XP on the session itself so the client (and any
      // audit tooling) can see what the server actually credited.
      tx.update(snap.ref, {
        verifiedDurationMinutes: minutes,
        xpAwarded: xp,
      });

      tx.set(
        userRef,
        {
          xp: FieldValue.increment(xp),
          minutesPerWeek: FieldValue.increment(minutes),
          timesLockedIn: FieldValue.increment(1),
          currentStreak,
          longestStreak: Math.max(longestStreak, currentStreak),
          lastStudyDay: Timestamp.fromDate(today),
          lastActiveAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    });

    logger.info("Session scored", {
      sessionId: snap.id,
      userId,
      minutes,
      xp,
    });
  },
);

/** Returns the start of the given date in UTC — for consistent streak math. */
function startOfUTCDay(d: Date): Date {
  return new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
}

/**
 * Leaderboard refresher + weekly rollover + stale-snapshot GC.
 *
 *   refreshLeaderboards    — every 15 min.
 *     leaderboards/allTime/entries/{userId}   ranked by users.xp
 *     leaderboards/weekly/{weekId}/entries/{userId}
 *                                             ranked by users.minutesPerWeek
 *     Also deletes any entries that have fallen out of the top-N so old
 *     rankings don't pile up forever, and writes a tiny index doc at
 *     leaderboards/weeklyIndex/{weekId} so the GC job knows which weeks exist.
 *
 *   rolloverWeeklyStats    — every Monday 00:00 UTC.
 *     For every user, snapshot `previousWeekPoints = xp` and zero
 *     `minutesPerWeek` so the new week starts fresh. iOS uses
 *     `previousWeekPoints` to show how much XP was earned this week vs
 *     last week.
 *
 *   gcOldWeeklySnapshots   — every Sunday 04:00 UTC.
 *     Walks leaderboards/weeklyIndex and deletes any snapshot older than
 *     WEEKS_TO_KEEP weeks.
 *
 * For the MVP we scan the top 500 users. Once you have more than a few
 * thousand active users, switch to incremental updates driven by
 * onSessionCreated, or materialize ranks via a BigQuery / pub-sub pipeline.
 */

import { onSchedule } from "firebase-functions/v2/scheduler";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

const TOP_N = 500;
const BATCH_SIZE = 400; // Firestore's batch limit is 500; leave headroom.
const WEEKS_TO_KEEP = 12;

export const refreshLeaderboards = onSchedule(
  {
    schedule: "every 15 minutes",
    timeZone: "UTC",
  },
  async () => {
    const db = getFirestore();

    // --- all-time ---
    const allTimeSnap = await db
      .collection("users")
      .orderBy("xp", "desc")
      .limit(TOP_N)
      .get();

    await writeRanked(
      db,
      "leaderboards/allTime/entries",
      allTimeSnap.docs.map((d) => ({
        userId: d.id,
        displayName: d.get("displayName") ?? "",
        photoURL: d.get("photoURL") ?? null,
        score: (d.get("xp") as number) ?? 0,
      })),
    );

    // --- weekly ---
    const weeklySnap = await db
      .collection("users")
      .orderBy("minutesPerWeek", "desc")
      .limit(TOP_N)
      .get();

    const weekId = isoWeekId(new Date());
    await writeRanked(
      db,
      `leaderboards/weekly/${weekId}/entries`,
      weeklySnap.docs.map((d) => ({
        userId: d.id,
        displayName: d.get("displayName") ?? "",
        photoURL: d.get("photoURL") ?? null,
        score: (d.get("minutesPerWeek") as number) ?? 0,
      })),
    );

    // Record this weekId in a flat index so gcOldWeeklySnapshots can find it.
    await db
      .doc(`leaderboards/weeklyIndex/${weekId}`)
      .set({ weekId, lastRefreshedAt: Timestamp.now() }, { merge: true });

    logger.info("Leaderboards refreshed", {
      weekId,
      allTime: allTimeSnap.size,
      weekly: weeklySnap.size,
    });
  },
);

/**
 * At the start of each ISO week (Monday 00:00 UTC):
 *   - snapshot `previousWeekPoints = xp`     (iOS uses this for weekly delta)
 *   - zero `minutesPerWeek`                  (next week's counter starts fresh)
 *
 * Runs in batches so we don't OOM on large user bases.
 */
export const rolloverWeeklyStats = onSchedule(
  {
    schedule: "every monday 00:00",
    timeZone: "UTC",
  },
  async () => {
    const db = getFirestore();
    let processed = 0;
    let lastDoc: FirebaseFirestore.QueryDocumentSnapshot | undefined;

    // Scan every user, paginated by document id.
    // eslint-disable-next-line no-constant-condition
    while (true) {
      let q = db.collection("users").orderBy("__name__").limit(BATCH_SIZE);
      if (lastDoc) q = q.startAfter(lastDoc);

      const page = await q.get();
      if (page.empty) break;

      const batch = db.batch();
      page.docs.forEach((d) => {
        batch.update(d.ref, {
          previousWeekPoints: (d.get("xp") as number) ?? 0,
          minutesPerWeek: 0,
          updatedAt: Timestamp.now(),
        });
      });
      await batch.commit();

      processed += page.size;
      lastDoc = page.docs[page.docs.length - 1];
      if (page.size < BATCH_SIZE) break;
    }

    logger.info("Weekly stats rolled over", { usersUpdated: processed });
  },
);

/**
 * Prunes weekly leaderboard snapshots older than WEEKS_TO_KEEP.
 * Walks leaderboards/weeklyIndex and deletes anything older than the cutoff.
 */
export const gcOldWeeklySnapshots = onSchedule(
  {
    schedule: "every sunday 04:00",
    timeZone: "UTC",
  },
  async () => {
    const db = getFirestore();
    const cutoff = nWeeksAgoId(new Date(), WEEKS_TO_KEEP);

    const indexSnap = await db.collection("leaderboards/weeklyIndex").get();
    let deleted = 0;

    for (const indexDoc of indexSnap.docs) {
      // weekIds are ISO-formatted ("2026-W16") so string comparison works.
      if (indexDoc.id < cutoff) {
        await deleteCollection(db, `leaderboards/weekly/${indexDoc.id}/entries`);
        await indexDoc.ref.delete();
        deleted += 1;
      }
    }

    logger.info("Stale weekly snapshots GC complete", {
      deletedWeeks: deleted,
      cutoff,
    });
  },
);

async function writeRanked(
  db: FirebaseFirestore.Firestore,
  basePath: string,
  rows: {
    userId: string;
    displayName: string;
    photoURL: string | null;
    score: number;
  }[],
) {
  const now = Timestamp.now();

  // --- write the new top-N ---
  if (rows.length > 0) {
    const batch = db.batch();
    rows.forEach((r, i) => {
      batch.set(db.doc(`${basePath}/${r.userId}`), {
        userId: r.userId,
        displayName: r.displayName,
        photoURL: r.photoURL,
        score: r.score,
        rank: i + 1,
        updatedAt: now,
      });
    });
    await batch.commit();
  }

  // --- GC stale entries that have fallen out of the top-N ---
  const keep = new Set(rows.map((r) => r.userId));
  const existing = await db.collection(basePath).listDocuments();
  let staleBatch = db.batch();
  let staleCount = 0;
  let batchCount = 0;
  for (const ref of existing) {
    if (keep.has(ref.id)) continue;
    staleBatch.delete(ref);
    batchCount += 1;
    staleCount += 1;
    if (batchCount >= BATCH_SIZE) {
      await staleBatch.commit();
      staleBatch = db.batch();
      batchCount = 0;
    }
  }
  if (batchCount > 0) await staleBatch.commit();

  if (staleCount > 0) {
    logger.debug("Pruned stale leaderboard entries", { basePath, staleCount });
  }
}

/** Recursively deletes a (shallow) collection in batches. */
async function deleteCollection(
  db: FirebaseFirestore.Firestore,
  path: string,
) {
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const page = await db.collection(path).limit(BATCH_SIZE).get();
    if (page.empty) return;
    const batch = db.batch();
    page.docs.forEach((d) => batch.delete(d.ref));
    await batch.commit();
    if (page.size < BATCH_SIZE) return;
  }
}

/** Returns e.g. "2026-W16" (ISO-8601 week format). */
function isoWeekId(d: Date): string {
  const date = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  // Thursday of the current ISO week determines the ISO year.
  const dayNum = (date.getUTCDay() + 6) % 7;
  date.setUTCDate(date.getUTCDate() - dayNum + 3);
  const firstThursday = new Date(Date.UTC(date.getUTCFullYear(), 0, 4));
  const week =
    1 +
    Math.round(
      ((date.getTime() - firstThursday.getTime()) / 86400000 -
        3 +
        ((firstThursday.getUTCDay() + 6) % 7)) /
        7,
    );
  return `${date.getUTCFullYear()}-W${String(week).padStart(2, "0")}`;
}

/** ISO week ID of `weeks` weeks before d. */
function nWeeksAgoId(d: Date, weeks: number): string {
  const past = new Date(d.getTime() - weeks * 7 * 24 * 60 * 60 * 1000);
  return isoWeekId(past);
}

# LOCKD Backend — Setup Guide

This guide walks Nathan and Katie through getting the Firebase backend running locally and deployed. Expect the initial setup to take about 45 minutes the first time.

## 0. One-time prerequisites

Install these on your machine:

- Node.js 20 LTS (`node -v` should print `v20.x`)
- Firebase CLI: `npm install -g firebase-tools`
- Java JDK 21+ (required for the Firestore/Storage emulators — they error on JDK 17 now)
- Git
- Xcode (for iOS work — separate concern, but you'll want the iOS SDK in the same project)

Create a Google account you both can use for the Firebase project, or have one of you own it and add the other as an editor.

## 1. Create the Firebase project

1. Go to <https://console.firebase.google.com> and click **Add project**.
2. Name it `lockd-dev` (we'll add a separate `lockd-prod` later — don't share a project between dev and prod).
3. Disable Google Analytics for now (you can add it later).
4. Once the project is created:
   - **Authentication → Sign-in method** → enable **Apple** and **Email/Password**.
   - **Firestore Database** → **Create database** → start in **production mode** → pick a region close to your users (e.g. `us-west1`).
   - **Storage** → **Get started** → production mode, same region as Firestore.
5. **Project settings → General → Your apps → Add app → iOS**. Register with bundle ID `com.lockd.app` (or whatever Chris/Luke decide). Download `GoogleService-Info.plist` and hand it to the frontend team.

## 2. Clone & install

```bash
git clone https://github.com/hcp-uw/healthiest-people-hcp.git
cd healthiest-people-hcp
# Drop the contents of this backend/ folder in at the repo root, or keep it as backend/
cd backend/functions
npm install
```

## 3. Link the CLI to your project

```bash
firebase login
cd backend
firebase use --add
# Pick lockd-dev and alias it as "default"
```

This creates `.firebaserc` — commit it so your teammates don't have to repeat this step.

## 4. Run the emulators

You'll do **all** development against the emulators, not the live project. It's faster, free, and can't leak real data.

```bash
cd backend/functions
npm run build
cd ..
firebase emulators:start
```

Open <http://localhost:4000> for the Emulator UI. You can:

- Create test users in the Auth emulator
- Browse/edit Firestore docs
- See Cloud Functions logs in real time

Point the iOS app at the emulators during development. In Swift:

```swift
#if DEBUG
  Auth.auth().useEmulator(withHost: "localhost", port: 9099)
  Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
  Storage.storage().useEmulator(withHost: "localhost", port: 9199)
  Functions.functions().useEmulator(origin: "http://localhost:5001")
#endif
```

## 5. Deploy

Once a feature is working in the emulator:

```bash
cd backend
firebase deploy --only firestore:rules,storage,functions
# or, to deploy everything:
firebase deploy
```

Deploys are gated by the predeploy build in `firebase.json`, so TypeScript errors will stop a deploy.

## 6. Folder layout

```
backend/
├── BACKEND_SETUP.md       (this file)
├── DATA_MODEL.md          Firestore schema + rules rationale
├── firebase.json          CLI config
├── firestore.rules        Firestore security rules
├── firestore.indexes.json Composite indexes
├── storage.rules          Storage security rules
└── functions/
    ├── package.json
    ├── tsconfig.json
    └── src/
        ├── index.ts         entry — re-exports triggers
        ├── users.ts         onUserCreated, onUserDocDelete, claimUsername
        ├── sessions.ts      onSessionCreated → XP + streaks
        ├── posts.ts         createPostFromSession callable
        ├── social.ts        comment/reaction counters + post cascade delete
        └── leaderboards.ts  refreshLeaderboards + rolloverWeeklyStats + gcOldWeeklySnapshots
```

Exported Cloud Functions (12 total):

| Name | Kind | Purpose |
|---|---|---|
| `onUserCreated` | v1 Auth trigger | Seeds `users/{uid}` on first sign-in |
| `onUserDocDelete` | v2 Firestore trigger | Releases reserved username |
| `claimUsername` | v2 HTTPS callable | Transactionally claims a unique handle |
| `onSessionCreated` | v2 Firestore trigger | Clamps duration, awards XP (1/min), updates streak |
| `createPostFromSession` | v2 HTTPS callable | Creates a post linked to a verified session |
| `onCommentCreated` / `onCommentDeleted` | v2 Firestore triggers | Keep `posts.commentCount` in sync |
| `onReactionWritten` | v2 Firestore trigger | Keeps `posts.reactionCount` in sync |
| `onPostDeleted` | v2 Firestore trigger | Cascade deletes comments/reactions, decrements `postCount` |
| `refreshLeaderboards` | v2 scheduler (every 15 min) | Rewrites all-time + current-week top 500 |
| `rolloverWeeklyStats` | v2 scheduler (Mon 00:00 UTC) | Snapshots `previousWeekPoints = xp`, zeros `minutesPerWeek` |
| `gcOldWeeklySnapshots` | v2 scheduler (Sun 04:00 UTC) | Deletes weekly snapshots older than 12 weeks |

## 7. Suggested first PRs

Once you've done the setup above, split the work:

1. **Katie** — authentication & user profile doc creation. Verify onUserCreated fires in the emulator, write the security rules for `users/{uid}`, and hand the frontend a `UserService` pattern to follow.
2. **Nathan** — study session flow. Hook up Storage uploads, create `sessions/` docs, verify onSessionCreated awards the right XP. Add a unit test using the Firestore emulator.
3. **Together** — feed + reactions + comments. These all share the `posts/{postId}` doc and its subcollections, so pair on the rules.
4. **Last** — leaderboards. Let the data pile up for a week in dev so the rankings aren't empty when you test.

## 8. Watch-outs

- **Never deploy straight to prod.** Always test in `lockd-dev` first.
- **Never set XP / streak / counter fields from the iOS client.** The rules will reject the write, and even if they didn't, it would open you up to cheating.
- **Paginate every feed query.** `limit(20)` with a cursor, always.
- **Don't log PII** from Cloud Functions. `functions.logger` lands in Cloud Logging where anyone with project access can see it.
- **Budget alerts.** Set a $25/mo budget alert in Google Cloud Billing so nobody gets a surprise bill.

## 9. Good references

- Firestore data modeling: <https://firebase.google.com/docs/firestore/data-model>
- Security rules cookbook: <https://firebase.google.com/docs/rules/rules-and-auth>
- Cloud Functions 2nd gen migration notes: <https://firebase.google.com/docs/functions/version-comparison>
- Emulator suite: <https://firebase.google.com/docs/emulator-suite>

# Firebase / Firestore setup

This doc is for the **iOS side** of the stack. The server-side pieces
(rules, indexes, Cloud Functions) all live in [`backend/`](../backend/) —
see [`backend/BACKEND_SETUP.md`](../backend/BACKEND_SETUP.md) for how to
install the Firebase CLI, run the emulator suite, and deploy.

## 1. Add Firebase to the project

1. In Xcode: **File → Add Package Dependencies…**, enter:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
2. Add these products to your app target:
   - **FirebaseAuth**
   - **FirebaseFirestore**
   - **FirebaseFirestoreSwift**
   - **FirebaseFunctions**  (needed for `claimUsername` + `createPostFromSession`)
   - **FirebaseStorage**    (for video + thumbnail uploads)
3. Download **GoogleService-Info.plist** from the
   [Firebase Console](https://console.firebase.google.com/) (Project →
   your iOS app) and add it to the app target.

## 2. Configure Firebase at launch

In **LockDApp.swift**:

```swift
import SwiftUI
import FirebaseCore

@main
struct LockDApp: App {
    init() {
        FirebaseApp.configure()
    }

    @StateObject private var session = AppSession(
        userRepository: FirebaseUserRepository(),
        feedService: FirebaseFeedService()
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
```

Until `FirebaseApp.configure()` is called, `Auth.auth()` and
`Firestore.firestore()` will crash. Put it first in `init()`.

## 3. Point at the emulator during development

Once you have `backend/` checked out and `firebase emulators:start`
running, do this from the app's startup code, guarded so production
builds still hit the real project:

```swift
#if DEBUG
Auth.auth().useEmulator(withHost: "localhost", port: 9099)
let fs = Firestore.firestore()
let settings = fs.settings
settings.host = "localhost:8080"
settings.isPersistenceEnabled = false
settings.isSSLEnabled = false
fs.settings = settings
Storage.storage().useEmulator(withHost: "localhost", port: 9199)
Functions.functions().useEmulator(origin: "http://localhost:5001")
#endif
```

## 4. Schema

Field names on the three Firestore collections match the iOS Codable
structs exactly (`LockDUser.swift`, `Post.swift`, `StudySession.swift`),
so reads can use `snapshot.data(as: LockDUser.self)` directly with no
remapping. Server-internal fields (counters, streak scaffolding,
leaderboard metadata) live alongside the model fields; Codable ignores
them.

See [`backend/DATA_MODEL.md`](../backend/DATA_MODEL.md) for the full
schema, including what the client is and isn't allowed to write.

## 5. Two server-mediated flows

A couple of operations **must** go through Cloud Functions — the rules
explicitly block the direct-write path:

### Claim a username

```swift
import FirebaseFunctions

let functions = Functions.functions()
let result = try await functions
    .httpsCallable("claimUsername")
    .call(["username": "joylockd"])
```

Transactionally reserves the handle and writes it onto
`users/{uid}.username`.

### Publish a post

The client:
1. Creates a `sessions/{sessionId}` doc with `userId`, `taskType`,
   `description`, `durationMinutes`, `createdAt`.
2. Waits ~1s for `onSessionCreated` to score the session (it sets
   `verifiedDurationMinutes` and `xpAwarded`).
3. Uploads `videos/{uid}/{sessionId}.mp4` and
   `thumbnails/{uid}/{sessionId}.jpg` to Storage.
4. Calls `createPostFromSession` with the two download URLs:

```swift
let result = try await Functions.functions()
    .httpsCallable("createPostFromSession")
    .call([
        "sessionId": sessionId,
        "videoURL": videoDownloadURL,
        "thumbnailURL": thumbDownloadURL,
        "caption": caption,
    ])
```

The returned `{ "postId": "…" }` can be used to navigate to the new post.

## 6. Security rules

The real rules live in
[`backend/firestore.rules`](../backend/firestore.rules) and
[`backend/storage.rules`](../backend/storage.rules). Don't paste rules
into the Firebase Console web UI — deploy from the repo:

```bash
cd backend
firebase deploy --only firestore:rules,storage
```

The highlights:
- Clients can't write `users.xp`, streaks, any counter, or any timestamp
  the server owns.
- `posts/{postId}` is create-blocked for clients; only
  `createPostFromSession` can make a post.
- Authors can edit only `posts.caption`, never counts or author fields.
- All `leaderboards/**` is read-only for clients.

//
//  FirebaseFeedService.swift
//  LockD
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Firestore-backed. not implemented yet
final class FirebaseFeedService: FeedServiceProtocol {
    private let posts = Firestore.firestore().collection("posts")

    func getFeed(limit: Int = 30) async throws -> [Post] {
        let snapshot = try await posts
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            guard var post = try? doc.data(as: Post.self) else { return nil }
            post.id = doc.documentID
            return post
        }
    }
}

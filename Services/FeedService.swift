//
//  FeedService.swift
//  LockD
//

import Foundation

/// Still in mock state
protocol FeedServiceProtocol {
    func getFeed() async throws -> [Post]
}

/// Mock FeedService for backend temp test
struct MockFeedService: FeedServiceProtocol {
    func getFeed() async throws -> [Post] {
        [
            Post(
                id: "1",
                authorId: "u1",
                authorName: "Craire Lee",
                videoURL: "",
                createdAt: Date().addingTimeInterval(-23 * 60)
            ),
            Post(
                id: "2",
                authorId: "u2",
                authorName: "John Doe",
                caption: "Late night study session",
                videoURL: "",
                createdAt: Date().addingTimeInterval(-2 * 3600)
            ),
        ]
    }
}

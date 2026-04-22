//
//  AppSession.swift
//  LockD
//

import SwiftUI

/// Holds app-wide services.
// Useful Methods:
// session.userRepository.getCurrentUser() or
// session.feedService.getFeed() -> [Post]
// session.userrepository.getUser(id: String) -> LockDUser?

final class AppSession: ObservableObject {
    let userRepository: UserRepositoryProtocol
    let feedService: FeedServiceProtocol

    init(
        userRepository: UserRepositoryProtocol = MockUserRepository(),
        feedService: FeedServiceProtocol = MockFeedService()
    ) {
        self.userRepository = userRepository
        self.feedService = feedService
    }
}

//
//  UserRepository.swift
//  LockD
//

import Foundation

/// Full user data access: current user, fetch by ID, and update. Conforms to `UserServiceProtocol` so it can be used wherever only “current user” is needed.
protocol UserRepositoryProtocol: UserServiceProtocol {
    func getUser(id: String) async throws -> LockDUser?
    /// Create or overwrite a user (e.g. after sign-up or profile edit).
    func updateUser(_ user: LockDUser) async throws
}

/// Mock implementation testing
final class MockUserRepository: UserRepositoryProtocol {
    private var store: [String: LockDUser] = [:]

    init(initialUser: LockDUser? = nil) {
        if let user = initialUser ?? Self.defaultMockUser() {
            store[user.id] = user
        }
    }

    func getCurrentUser() async throws -> LockDUser? {
        // mock, return the first (or only) user.
        store.values.first
    }

    func getUser(id: String) async throws -> LockDUser? {
        store[id]
    }

    func updateUser(_ user: LockDUser) async throws {
        store[user.id] = user
    }

    private static func defaultMockUser() -> LockDUser {
        LockDUser(
            id: "mock",
            displayName: "You",
            currentStreak: 15,
            timesLockedIn: 42,
            minutesPerWeek: 120
        )
    }
}

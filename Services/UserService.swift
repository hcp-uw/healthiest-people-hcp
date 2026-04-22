//
//  UserService.swift
//  LockD
//

import Foundation

/// Implemented for current user only
/// For fetch-by-ID and update, use `UserRepositoryProtocol` instead, diff styles
protocol UserServiceProtocol {
    /// returns user currently authenticated
    func getCurrentUser() async throws -> LockDUser?
}

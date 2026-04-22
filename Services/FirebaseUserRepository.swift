//
//  FirebaseUserRepository.swift
//  LockD
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Firestore-backed user repository. Incomplete without firebase.
final class FirebaseUserRepository: UserRepositoryProtocol {
    private let users = Firestore.firestore().collection("users")

    func getCurrentUser() async throws -> LockDUser? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return try await getUser(id: uid)
    }

    func getUser(id: String) async throws -> LockDUser? {
        let snapshot = try await users.document(id).getDocument()
        guard snapshot.exists else { return nil }
        var user = try snapshot.data(as: LockDUser.self)
        user.id = snapshot.documentID
        return user
    }

    func updateUser(_ user: LockDUser) async throws {
        var copy = user
        copy.updatedAt = Date()
        try users.document(copy.id).setData(from: copy, merge: true)
    }
}

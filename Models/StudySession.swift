//
//  StudySession.swift
//  LockD
//

import Foundation

/// A single “locked in” session; 1 XP per minute. Stored in Firestore `sessions/{sessionId}`.
struct StudySession: Identifiable, Codable, Equatable {
    var id: String
    var userId: String
    var taskType: String  // e.g. "Studying", "Coding"
    var description: String?
    var durationMinutes: Int
    var createdAt: Date

    init(
        id: String,
        userId: String,
        taskType: String,
        description: String? = nil,
        durationMinutes: Int,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.taskType = taskType
        self.description = description
        self.durationMinutes = durationMinutes
        self.createdAt = createdAt
    }

    var xpEarned: Int { durationMinutes }
}

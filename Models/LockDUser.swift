//
//  LockDUser.swift
//  LockD
//

import Foundation

/// User profile and stats stored in Firestore `users/{userId}`.
struct LockDUser: Identifiable, Codable, Equatable {
    var id: String
    var displayName: String
    var photoURL: String?
    var xp: Int
    var currentStreak: Int
    var timesLockedIn: Int
    var minutesPerWeek: Int
    var lastActiveAt: Date?
    /// Points at end of previous week; used to compute leaderboard delta.
    var previousWeekPoints: Int
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String,
        displayName: String,
        photoURL: String? = nil,
        xp: Int = 0,
        currentStreak: Int = 0,
        timesLockedIn: Int = 0,
        minutesPerWeek: Int = 0,
        lastActiveAt: Date? = nil,
        previousWeekPoints: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL
        self.xp = xp
        self.currentStreak = currentStreak
        self.timesLockedIn = timesLockedIn
        self.minutesPerWeek = minutesPerWeek
        self.lastActiveAt = lastActiveAt
        self.previousWeekPoints = previousWeekPoints
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// Level from XP: 250 XP per level starting at 1.
    var level: Int {
        max(1, (xp / 250) + 1)
    }

    /// XP needed for current level (e.g. 250, 500, 750…).
    var xpForCurrentLevel: Int {
        (level - 1) * 250
    }

    /// XP needed to reach next level.
    var xpForNextLevel: Int {
        level * 250
    }

    /// Progress toward next level (0...1).
    var levelProgress: Double {
        let current = Double(xp - xpForCurrentLevel)
        let needed = Double(xpForNextLevel - xpForCurrentLevel)
        return needed > 0 ? min(1, current / needed) : 1
    }
}

//
//  Post.swift
//  LockD
//

import Foundation

/// Community feed post stored in Firestore `posts/{postId}`.
struct Post: Identifiable, Codable, Equatable {
    var id: String
    var authorId: String
    var authorName: String
    var authorPhotoURL: String?
    var videoURL: String
    var thumbnailURL: String?
    var caption: String?
    var createdAt: Date

    init(
        id: String,
        authorId: String,
        authorName: String,
        authorPhotoURL: String? = nil,
        videoURL: String,
        thumbnailURL: String? = nil,
        caption: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.authorId = authorId
        self.authorName = authorName
        self.authorPhotoURL = authorPhotoURL
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.caption = caption
        self.createdAt = createdAt
    }
}

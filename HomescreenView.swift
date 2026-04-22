//
//  HomescreenView.swift
//  LockD
//
//  Created by Hana Kang on 2/10/26.
//

import SwiftUI

struct HomescreenView: View {
    var hideFooter: Bool = false
    @EnvironmentObject private var session: AppSession

    /// Current user for streak and relevant stats (loaded from session.userRepository).
    @State private var currentUser: LockDUser?
    /// Community posts (loaded from session.feedService).
    @State private var posts: [Post] = []

    // local vars for loading state and error handling
    @State private var isLoading = false
    @State private var loadError: Error?

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.09, blue: 0.14) // Bg color from Figma
                .ignoresSafeArea()

            VStack(spacing: 20) {
                headerSection

                ScrollView {
                    VStack(spacing: 18) {
                        streakCard
                        communityFeed
                    }
                    .padding(.horizontal, 20)
                }
                .task {
                    await loadFromServices()
                }

                if !hideFooter {
                    customFooter
                }
            }
        }
    }

    private func loadFromServices() async {
        isLoading = true
        loadError = nil
        do {
            async let user = session.userRepository.getCurrentUser()
            async let feed = session.feedService.getFeed()
            currentUser = try await user
            posts = try await feed
        } catch {
            loadError = error
        }
        isLoading = false
    }
    
    var headerSection: some View {
        HStack {
            Text("L O C K D")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.82, green: 0.60, blue: 0.76).opacity(0.7), radius: 7)
            
            Spacer()
            
            HStack(spacing: 20) {
                Image(systemName: "bell.fill")
                Image(systemName: "line.3.horizontal")
            }
            .foregroundColor(.white)
            .font(.system(size: 20))
        }
        .padding(.horizontal, 25)
        .padding(.top, 10)
    }

    var streakCard: some View {
        let streak = currentUser?.currentStreak ?? 0
        return HStack {
            VStack(alignment: .leading) {
                Text("Focus Streak")
                    .font(.system(size: 20, weight: .bold)).italic()
                Text("\(streak)")
                    .font(.system(size: 40, weight: .heavy))
                Text("Days")
                    .font(.system(size: 20, weight: .bold)).italic()
            }
            Spacer()
            // image/logo placeholder
        }
        .padding()
        .background(Color(red: 0.96, green: 0.43, blue: 0.22)) // #F56E38
        .cornerRadius(10)
        .foregroundColor(.white)
    }

    var communityFeed: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Community")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            ForEach(posts) { post in
                postRow(post)
            }
        }
    }

    // Function to post data itself to the feed
    private func postRow(_ post: Post) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .stroke(Color(red: 0.82, green: 0.60, blue: 0.76), lineWidth: 2)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text(post.authorName)
                        .fontWeight(.bold)
                    Text(relativeTime(from: post.createdAt))
                        .font(.caption)
                        .foregroundColor(Color(red: 0.37, green: 0.74, blue: 0.84))
                }
                Spacer()
            }
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(
                    Group {
                        if let caption = post.caption, !caption.isEmpty {
                            Text(caption)
                                .foregroundColor(.white.opacity(0.5))
                        } else {
                            Text("Timelapse Video")
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                )
        }
        .foregroundColor(.white)
    }

    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    /// Test function to load mock data for visual inspection
    private func loadMockData() {
        currentUser = LockDUser(
            id: "mock",
            displayName: "You",
            currentStreak: 15,
            timesLockedIn: 42,
            minutesPerWeek: 120
        )
        posts = [
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
                authorName: "Alex Productive",
                caption: "Late night study session",
                videoURL: "",
                createdAt: Date().addingTimeInterval(-2 * 3600)
            ),
        ]
    }

    var customFooter: some View {
        HStack {
            Spacer()
            Image(systemName: "house.fill")
            Spacer()
            Image(systemName: "trophy.fill")
            Spacer()
            Image(systemName: "person.fill")
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14))
        .foregroundColor(.white)
        .font(.system(size: 24))
    }

}
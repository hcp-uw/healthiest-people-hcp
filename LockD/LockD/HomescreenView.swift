//
//  HomescreenView.swift
//  LockD
//
//  Created by Hana Kang on 2/10/26.
//

import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let userName: String
    let timeAgo: String
    let title: String
    let category: String
}

struct HomescreenView: View {
    var hideFooter: Bool = false
    
    let posts = [
        Post(userName: "Ariana Li", timeAgo: "23m ago", title: "Drawing Practice", category: "Art"),
        Post(userName: "Craire Lee", timeAgo: "1h ago", title: "SwiftUI Coding", category: "Tech"),
        Post(userName: "Christoph Chen", timeAgo: "3h ago", title: "Morning Yoga", category: "Wellness")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.12, green: 0.09, blue: 0.14).ignoresSafeArea()
                            
                VStack(spacing: 0) {
                    headerSection
                        .padding(.bottom, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            // Streak Card navigates to Recording
                            NavigationLink(destination: RecordingView()) {
                                streakCard
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            communityFeedSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                    }
                    
                    // The Navigation Bar (Like Leaderboard)
                    if !hideFooter {
                        navigationFooter
                    }
                }
            }
        }
    }
    
    // MARK: - Original Community Style
    var communityFeedSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Community")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(posts) { post in
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 36, height: 36)
                        
                        VStack(alignment: .leading) {
                            Text(post.userName).font(.system(size: 14, weight: .bold))
                            Text(post.timeAgo).font(.system(size: 12)).foregroundColor(.cyan)
                        }
                        Spacer()
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 220)
                        
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.title).font(.headline)
                        Text(post.category).font(.subheadline).opacity(0.7)
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
        }
    }

    // MARK: - Functional Navigation Footer
    var navigationFooter: some View {
        VStack(spacing: 0) {
            Divider().background(Color.white.opacity(0.1))
            
            HStack {
                Spacer()
                // Home Icon
                Image(systemName: "house.fill")
                    .foregroundColor(.white)
                
                Spacer()
                
                // NEW: Recording Page Navigation from Footer
                NavigationLink(destination: RecordingView()) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Trophy Icon
                Image(systemName: "trophy.fill")
                    .foregroundColor(.white.opacity(0.5))
                
                Spacer()
                
                // Profile Icon
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.5))
                
                Spacer()
            }
            .padding(.top, 15)
            .padding(.bottom, 35)
            .background(Color(red: 0.12, green: 0.09, blue: 0.14))
            .font(.system(size: 24))
        }
    }

    // MARK: - Header & Streak Card (Existing)
    var headerSection: some View {
        HStack {
            Text("L O C K D")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.82, green: 0.60, blue: 0.76).opacity(0.8), radius: 10)
            Spacer()
            HStack(spacing: 20) {
                Image(systemName: "bell.fill")
                Image(systemName: "line.3.horizontal")
            }
            .foregroundColor(.white)
        }
        .padding(.horizontal, 25)
    }
    
    var streakCard: some View {
        HStack(spacing: 20) {
            Image(systemName: "lock.fill").font(.system(size: 40))
            VStack(alignment: .leading, spacing: -5) {
                Text("15").font(.system(size: 48, weight: .black))
                Text("Days Focus Streak").font(.system(size: 16, weight: .bold)).italic()
            }
            Spacer()
            Image(systemName: "chevron.right").opacity(0.5)
        }
        .padding(25)
        .background(Color(red: 0.96, green: 0.43, blue: 0.22))
        .cornerRadius(20)
        .foregroundColor(.white)
    }
}

struct RecordingView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.09, blue: 0.14).ignoresSafeArea()
            VStack(spacing: 30) {
                Text("2:34:08")
                    .font(.system(size: 64, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                Button("STOP") { dismiss() }
                    .foregroundColor(.red)
                    .font(.title)
            }
        }
    }
}

#Preview {
    HomescreenView()
}

//
//  LeaderboardView.swift
//  LockD
//
//  Created by Nathan Tran on 2/18/26.
//

import SwiftUI

struct LeaderboardView: View {
    let hideFooter: Bool

    struct LeaderboardEntry: Identifiable {
        let id = UUID()
        let rank: Int
        let name: String
        let points: Int
        let delta: Int // positive=up, negative=down, 0=flat
    }

    private var mockData: [LeaderboardEntry] {
        [
            .init(rank: 1, name: "Marcus Johnson", points: 2847, delta: 2),
            .init(rank: 2, name: "Olivia Martinez", points: 2641, delta: 1),
            .init(rank: 3, name: "Sarah Chen", points: 2438, delta: -1),
            .init(rank: 4, name: "John Smith", points: 2310, delta: 2),
            .init(rank: 5, name: "Emma Rodriguez", points: 2089, delta: 0),
            .init(rank: 6, name: "Alex Productive", points: 1956, delta: 1),
            .init(rank: 7, name: "Liam O'Connor", points: 1724, delta: -2),
            .init(rank: 8, name: "Priya Sharma", points: 1621, delta: 1),
        ]
    }

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.09, blue: 0.14).ignoresSafeArea()

            VStack(spacing: 20) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        weeklyRankingCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }

    private var header: some View {
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

    private var weeklyRankingCard: some View {
        VStack(spacing: 12) {
            // Title pill
            Text("WEEKLY RANKING")
                .font(.system(size: 14, weight: .heavy))
                .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(Color(red: 0.23, green: 0.07, blue: 0.42))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.6), lineWidth: 0.5)
                        )
                )
                .padding(.top, 14)

            // Card container
            VStack(spacing: 0) {
                ForEach(mockData) { entry in
                    LeaderboardRow(entry: entry)
                    if entry.rank != mockData.count {
                        Divider()
                            .background(Color.white.opacity(0.2))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .shadow(color: Color(red: 0, green: 0.23, blue: 0.62, opacity: 0.25), radius: 30, x: 0, y: 20)
        }
    }
}
private struct LeaderboardRow: View {
    let entry: LeaderboardView.LeaderboardEntry

    var body: some View {
        HStack(spacing: 12) {
            // Rank icon / number
            ZStack {
                Circle()
                    .fill(Color(red: 0.23, green: 0.07, blue: 0.42))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.5), lineWidth: 0.5)
                    )
                Text("\(entry.rank)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 40)

            // Avatar placeholder matching style
            ZStack {
                Circle()
                    .fill(Color(red: 0.32, green: 0.42, blue: 1))
                    .frame(width: 46, height: 46)
                Circle()
                    .fill(Color(red: 0.24, green: 0.21, blue: 0.21))
                    .frame(width: 40, height: 40)
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 10)

            // Name and points
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                HStack(spacing: 6) {
                    Text("\(entry.points).")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                    deltaView
                }
            }

            Spacer()

            // Right aligned points and movement
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.points).")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                deltaView
            }
        }
        .padding(.horizontal, 14)
        .background(Color.clear)
    }

    @ViewBuilder
    private var deltaView: some View {
        if entry.delta > 0 {
            HStack(spacing: 2) {
                Image(systemName: "arrow.up")
                Text("\(entry.delta)")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(Color.green)
        } else if entry.delta < 0 {
            HStack(spacing: 2) {
                Image(systemName: "arrow.down")
                Text("\(-entry.delta)")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(Color.red)
        } else {
            HStack(spacing: 4) {
                Circle().frame(width: 4, height: 4)
                Text("=")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.gray)
        }
    }
}


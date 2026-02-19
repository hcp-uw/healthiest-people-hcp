//
//  HomescreenView.swift
//  LockD
//
//  Created by Hana Kang on 2/10/26.
//

import SwiftUI

struct HomescreenView: View {
    var hideFooter: Bool = false

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

                if !hideFooter {
                    customFooter
                }
            }
        }
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
        HStack {
            VStack(alignment: .leading) {
                Text("Focus Streak")
                    .font(.system(size: 20, weight: .bold)).italic()
                Text("15")
                    .font(.system(size: 40, weight: .heavy))
                Text("Days")
                    .font(.system(size: 20, weight: .bold)).italic()
            }
            Spacer()
            // image/logo palceholder
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
            
            // One post
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .stroke(Color(red: 0.82, green: 0.60, blue: 0.76), lineWidth: 2)
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text("Craire Lee")
                            .fontWeight(.bold)
                        Text("23m ago")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.37, green: 0.74, blue: 0.84))
                    }
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("Timelapse Video").foregroundColor(.white.opacity(0.5)))
            }
            .foregroundColor(.white)
        }
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

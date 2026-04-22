//
//  ContentView.swift
//  LockD
//
//  Created by Joy Chang on 2/3/26.
//

import SwiftUI

enum MainTab {
    case home
    case trophy
    case profile
    case record
}

struct ContentView: View {
    @State private var selectedTab: MainTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomescreenView(hideFooter: true)
                case .trophy:
                    LeaderboardView(hideFooter: true)
                case .record:
                    RecordView(hideFooter: true)
                case .profile:
                    UserProfileView(hideFooter: true)
                }
            }
            tabBarOverlay
        }
    }

    private var tabBarOverlay: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .home
            } label: {
                Image(systemName: "house.fill")
            }
            Spacer()
            Button {
                selectedTab = .record
            } label: {
                Image(systemName: "camera.fill")
            }
            Spacer()
            Button {
                selectedTab = .trophy
            } label: {
                Image(systemName: "trophy.fill")
            }
            Spacer()
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person.fill")
            }
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14))
        .foregroundColor(.white)
        .font(.system(size: 24))
    }
}

#Preview {
    ContentView()
}

//
//  UserProfileView.swift
//  LockD
//
//  Created by Joy Chang on 2/3/26.
//

import SwiftUI


struct UserProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)

            Text("Joy Chang")
                .font(.title)

            Text("UW Informatics • Class of 2028")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

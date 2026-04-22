//
//  LockDApp.swift
//  LockD
//
//  Created by Joy Chang on 2/3/26.
//

import SwiftUI

@main
struct LockDApp: App {
    @StateObject private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}

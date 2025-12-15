//
//  CozyBountyApp.swift
//  CozyBounty
//
//  Created by liepin on 2025/12/15.
//

import SwiftUI

@main
struct CozyBountyApp: App {
    @StateObject private var store = BountyStore()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}

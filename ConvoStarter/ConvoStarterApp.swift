//
//  ConvoStarterApp.swift
//  ConvoStarter
//
//  Created by Andre van Tonder on 13/6/2025.
//

import SwiftUI
import WidgetKit

@main
struct ConvoStarterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    // Refresh widget timeline when app becomes active
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
    }
}

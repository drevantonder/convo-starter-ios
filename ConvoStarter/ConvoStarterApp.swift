//
//  ConvoStarterApp.swift
//  ConvoStarter
//
//  Created by Andre van Tonder on 13/6/2025.
//

import SwiftUI
import WidgetKit
import PostHog

@main
struct ConvoStarterApp: App {
    init() {
        let POSTHOG_API_KEY = "phc_4jCoDMn5iuwXshspqHHIyObV6KHdFzxAueMLuoZ5fPX"
        let config = PostHogConfig(apiKey: POSTHOG_API_KEY)
        PostHogSDK.shared.setup(config)
    }
    
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

//
//  ConvoStarterWidget.swift
//  ConvoStarterWidget
//
//  Created by Andre van Tonder on 13/6/2025.
//

import WidgetKit
import SwiftUI
import ConvoStarterShared

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), conversationText: "Start a conversation...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), conversationText: "Start a conversation...")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        ConversationService.shared.fetchLatestConversationStarter { result in
            let conversationText: String
            switch result {
            case .success(let conversationStarter):
                conversationText = conversationStarter.text
            case .failure(_):
                conversationText = "Failed to load conversation starter"
            }
            
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, conversationText: conversationText)
            
            // Refresh every 15 minutes instead of 30 for better sync
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate) ?? currentDate
            
            // Use .atEnd policy which allows the system to reload more frequently when needed
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let conversationText: String
}

struct ConvoStarterWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            Text(entry.conversationText)
                .font(.caption2)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        default:
            // Home screen widgets
            Text(entry.conversationText)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
    }
}

struct ConvoStarterWidget: Widget {
    let kind: String = "ConvoStarterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ConvoStarterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ConvoStarterWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .configurationDisplayName("Conversation Starter")
        .description("Get the latest conversation starter to break the ice.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    ConvoStarterWidget()
} timeline: {
    SimpleEntry(date: .now, conversationText: "What's the most interesting thing you've learned recently?")
    SimpleEntry(date: .now, conversationText: "If you could have dinner with anyone, living or dead, who would it be and why?")
}

#Preview(as: .accessoryRectangular) {
    ConvoStarterWidget()
} timeline: {
    SimpleEntry(date: .now, conversationText: "What's the most interesting thing you've learned recently?")
    SimpleEntry(date: .now, conversationText: "If you could have dinner with anyone, living or dead, who would it be and why?")
}

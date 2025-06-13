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
            
            // Refresh every 30 minutes
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate) ?? currentDate
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
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

    var body: some View {
        Text(entry.conversationText)
            .font(.body)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
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
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Conversation Starter")
        .description("Get the latest conversation starter to break the ice.")
    }
}

#Preview(as: .systemSmall) {
    ConvoStarterWidget()
} timeline: {
    SimpleEntry(date: .now, conversationText: "What's the most interesting thing you've learned recently?")
    SimpleEntry(date: .now, conversationText: "If you could have dinner with anyone, living or dead, who would it be and why?")
}

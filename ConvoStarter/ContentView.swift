//
//  ContentView.swift
//  ConvoStarter
//
//  Created by Andre van Tonder on 13/6/2025.
//

import SwiftUI
import ConvoStarterShared
import WidgetKit

struct ContentView: View {
    @State private var conversationText = "Loading..."
    @State private var isGenerating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(conversationText)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                generateNewConversationStarter()
            }) {
                Text(isGenerating ? "Generating..." : "Generate")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(isGenerating ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(isGenerating)
        }
        .padding()
        .onAppear {
            fetchConversationStarter()
        }
    }
    
    func fetchConversationStarter() {
        ConversationService.shared.fetchLatestConversationStarter { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let conversationStarter):
                    conversationText = conversationStarter.text
                case .failure(_):
                    conversationText = "Failed to load conversation starter"
                }
            }
        }
    }
    
    func generateNewConversationStarter() {
        isGenerating = true
        
        ConversationService.shared.generateNewConversationStarter { result in
            DispatchQueue.main.async {
                isGenerating = false
                
                switch result {
                case .success(let conversationStarter):
                    conversationText = conversationStarter.text
                    // Refresh the widget timeline to show the new conversation starter
                    WidgetCenter.shared.reloadAllTimelines()
                case .failure(_):
                    conversationText = "Failed to generate conversation starter"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

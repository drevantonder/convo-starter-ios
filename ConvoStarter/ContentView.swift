//
//  ContentView.swift
//  ConvoStarter
//
//  Created by Andre van Tonder on 13/6/2025.
//

import SwiftUI
import ConvoStarterShared

struct ContentView: View {
    @State private var conversationText = "Loading..."
    
    var body: some View {
        VStack {
            Text(conversationText)
                .multilineTextAlignment(.center)
                .padding()
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
}

#Preview {
    ContentView()
}

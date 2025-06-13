//
//  ContentView.swift
//  ConvoStarter
//
//  Created by Andre van Tonder on 13/6/2025.
//

import SwiftUI

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
        guard let url = URL(string: "https://convo-starters.drevan.me/api/conversation-starters/latest") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let text = json["text"] as? String {
                DispatchQueue.main.async {
                    conversationText = text
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}

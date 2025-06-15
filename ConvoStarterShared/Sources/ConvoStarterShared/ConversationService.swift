import Foundation

public struct ConversationStarter {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
}

public class ConversationService: @unchecked Sendable {
    public static let shared = ConversationService()
    
    private let apiURL = "https://convo-starters.drevan.me/api/conversation-starters/latest"
    private let generateURL = "https://convo-starters.drevan.me/api/conversation-starters/generate-and-save"
    
    private init() {}
    
    public func fetchLatestConversationStarter() async throws -> ConversationStarter {
        guard let url = URL(string: apiURL) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let text = json["text"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return ConversationStarter(text: text)
    }
    
    public func fetchLatestConversationStarter(completion: @escaping @Sendable (Result<ConversationStarter, Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let text = json["text"] as? String else {
                    completion(.failure(URLError(.cannotParseResponse)))
                    return
                }
                
                let conversationStarter = ConversationStarter(text: text)
                completion(.success(conversationStarter))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func generateNewConversationStarter() async throws -> ConversationStarter {
        guard let url = URL(string: generateURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let text = json["text"] as? String else {
            throw URLError(.cannotParseResponse)
        }
        
        return ConversationStarter(text: text)
    }
    
    public func generateNewConversationStarter(completion: @escaping @Sendable (Result<ConversationStarter, Error>) -> Void) {
        guard let url = URL(string: generateURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let text = json["text"] as? String else {
                    completion(.failure(URLError(.cannotParseResponse)))
                    return
                }
                
                let conversationStarter = ConversationStarter(text: text)
                completion(.success(conversationStarter))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
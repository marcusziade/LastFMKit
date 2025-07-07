import Foundation

public final class AuthAPI: BaseAPI {
    
    /// Get the auth URL from the worker (which has the API key)
    public func getAuthURL() async throws -> String {
        let endpoint = buildEndpoint(category: "auth", method: "url", parameters: [:], httpMethod: .get)
        let data = try await networkClient.request(endpoint) as Data
        
        // Parse JSON response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let authURL = json["auth_url"] as? String else {
            throw LastFMError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Missing auth_url in response")))
        }
        
        return authURL
    }
    
    public func getSession(token: String) async throws -> Session {
        let parameters = ["token": token]
        
        let endpoint = buildEndpoint(category: "auth", method: "getSession", parameters: parameters, httpMethod: .get)
        let response: AuthSessionResponse = try await networkClient.request(endpoint)
        return response.session
    }
    
    public func getMobileSession(username: String, password: String) async throws -> Session {
        let parameters = [
            "username": username,
            "password": password
        ]
        
        let endpoint = buildEndpoint(category: "auth", method: "getMobileSession", parameters: parameters, httpMethod: .get)
        let response: AuthMobileSessionResponse = try await networkClient.request(endpoint)
        return response.session
    }
}
import Foundation

/// Manages CLI configuration including auth sessions
public final class ConfigManager {
    private let configURL: URL
    
    public struct Config: Codable {
        var workerURL: String
        var apiKey: String?
        var outputFormat: String
        var auth: AuthConfig
        
        init() {
            self.workerURL = "https://lastfm-proxy-worker.guitaripod.workers.dev"
            self.apiKey = nil
            self.outputFormat = "pretty"
            self.auth = AuthConfig()
        }
    }
    
    public struct AuthConfig: Codable {
        var username: String?
        var sessionKey: String?
    }
    
    public init() {
        // Get config directory
        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        let configDir = homeURL.appendingPathComponent(".config/lastfm-cli")
        
        // Create directory if needed
        try? FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)
        
        self.configURL = configDir.appendingPathComponent("config.json")
    }
    
    /// Load configuration from disk
    public func load() -> Config {
        guard let data = try? Data(contentsOf: configURL),
              let config = try? JSONDecoder().decode(Config.self, from: data) else {
            return Config()
        }
        return config
    }
    
    /// Save configuration to disk
    public func save(_ config: Config) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(config)
        try data.write(to: configURL)
    }
    
    /// Get current session if available
    public func getSession() -> (username: String, sessionKey: String)? {
        let config = load()
        guard let username = config.auth.username,
              let sessionKey = config.auth.sessionKey else {
            return nil
        }
        return (username, sessionKey)
    }
    
    /// Save session
    public func saveSession(username: String, sessionKey: String) throws {
        var config = load()
        config.auth.username = username
        config.auth.sessionKey = sessionKey
        try save(config)
    }
    
    /// Clear session
    public func clearSession() throws {
        var config = load()
        config.auth.username = nil
        config.auth.sessionKey = nil
        try save(config)
    }
}
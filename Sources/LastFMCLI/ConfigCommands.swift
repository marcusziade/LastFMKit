import ArgumentParser
import Foundation

struct ConfigCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "config",
        abstract: "Configuration management commands",
        subcommands: [
            ConfigShow.self,
            ConfigSet.self,
            ConfigInit.self
        ]
    )
}

struct ConfigShow: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "show",
        abstract: "Show current configuration"
    )
    
    func run() async throws {
        let configManager = ConfigManager()
        let config = configManager.load()
        
        print("\nCurrent Configuration:")
        print("─────────────────────")
        print("Worker URL: \(config.workerURL)")
        print("API Key: \(config.apiKey ?? "Not set")")
        print("Output Format: \(config.outputFormat)")
        
        if let username = config.auth.username {
            print("\nAuthentication:")
            print("Username: \(username)")
            print("Session: \(config.auth.sessionKey != nil ? "Active" : "None")")
        } else {
            print("\nAuthentication: Not logged in")
        }
        
        print("\nConfig file: ~/.config/lastfm-cli/config.json")
    }
}

struct ConfigSet: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "set",
        abstract: "Set a configuration value"
    )
    
    @Argument(help: "Configuration key (apiKey, workerURL, outputFormat)")
    var key: String
    
    @Argument(help: "Value to set")
    var value: String
    
    func run() async throws {
        let configManager = ConfigManager()
        var config = configManager.load()
        
        switch key.lowercased() {
        case "apikey", "api-key", "api_key":
            config.apiKey = value.isEmpty ? nil : value
            print("API key \(value.isEmpty ? "cleared" : "set")")
            
        case "workerurl", "worker-url", "worker_url":
            config.workerURL = value
            print("Worker URL set to: \(value)")
            
        case "outputformat", "output-format", "output_format", "format":
            let validFormats = ["json", "table", "pretty", "compact"]
            guard validFormats.contains(value.lowercased()) else {
                print("Error: Invalid format '\(value)'")
                print("Valid formats: \(validFormats.joined(separator: ", "))")
                return
            }
            config.outputFormat = value.lowercased()
            print("Output format set to: \(value)")
            
        default:
            print("Error: Unknown configuration key '\(key)'")
            print("Valid keys: apiKey, workerURL, outputFormat")
            return
        }
        
        try configManager.save(config)
        print("\nConfiguration saved")
    }
}

struct ConfigInit: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initialize configuration with defaults"
    )
    
    @Option(help: "API key for Last.fm")
    var apiKey: String?
    
    func run() async throws {
        let configManager = ConfigManager()
        var config = ConfigManager.Config()
        
        // Set API key if provided
        if let apiKey = apiKey {
            config.apiKey = apiKey
        }
        
        try configManager.save(config)
        
        print("\nConfiguration initialized at: ~/.config/lastfm-cli/config.json")
        print("\nDefault configuration:")
        print("─────────────────────")
        print("Worker URL: \(config.workerURL)")
        print("API Key: \(config.apiKey ?? "Not set")")
        print("Output Format: \(config.outputFormat)")
        
        if config.apiKey == nil {
            print("\nNote: To use authentication features, you'll need to set an API key:")
            print("  lastfm-cli config set apiKey YOUR_API_KEY")
            print("\nTo get an API key, visit: https://www.last.fm/api/account/create")
        }
    }
}
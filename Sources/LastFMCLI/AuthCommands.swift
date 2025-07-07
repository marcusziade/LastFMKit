import ArgumentParser
import Foundation
import LastFMKit
#if os(macOS)
import AppKit
#elseif os(Linux)
import Glibc
#endif

struct AuthCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "auth",
        abstract: "Authentication-related commands",
        subcommands: [
            AuthLogin.self,
            AuthStatus.self,
            AuthLogout.self,
            AuthGetSession.self,
            AuthGetMobileSession.self
        ]
    )
}

struct AuthLogin: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "login",
        abstract: "Authenticate with Last.fm"
    )
    
    func run() async throws {
        let configManager = ConfigManager()
        let client = LastFMClient()
        
        // Get auth URL from worker (which has the API key)
        let authURL: String
        do {
            authURL = try await client.auth.getAuthURL()
        } catch {
            print("\nError: Failed to get auth URL from worker")
            print("Error details: \(error.localizedDescription)")
            return
        }
        
        print("Opening browser for authorization...")
        print("If the browser doesn't open, visit this URL:")
        print(authURL)
        print()
        
        // Try to open browser
        #if os(macOS)
        NSWorkspace.shared.open(URL(string: authURL)!)
        #elseif os(Linux)
        let _ = system("xdg-open '\(authURL)'")
        #endif
        
        print("After authorizing, you'll be redirected to a page showing an auth token.")
        print("Please enter the token here:")
        print()
        print("Token: ", terminator: "")
        
        guard let token = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("Error: Failed to read token")
            return
        }
        
        do {
            let session = try await client.auth.getSession(token: token)
            try configManager.saveSession(username: session.name, sessionKey: session.key)
            print("\n✓ Successfully authenticated as '\(session.name)'")
        } catch {
            print("\nFailed to authenticate: \(error.localizedDescription)")
        }
    }
}

struct AuthStatus: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "status",
        abstract: "Check authentication status"
    )
    
    func run() async throws {
        let configManager = ConfigManager()
        
        if let session = configManager.getSession() {
            print("\nAuthenticated: Yes")
            print("Username: \(session.username)")
        } else {
            print("\nAuthenticated: No")
            print("Use 'lastfm-cli auth login' to authenticate")
        }
    }
}

struct AuthLogout: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "logout",
        abstract: "Log out and clear session"
    )
    
    func run() async throws {
        let configManager = ConfigManager()
        
        do {
            try configManager.clearSession()
            print("\nSuccessfully logged out")
        } catch {
            print("\nFailed to logout: \(error.localizedDescription)")
        }
    }
}

struct AuthGetSession: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "get-session",
        abstract: "Get a session key from a token"
    )
    
    @Argument(help: "Authentication token")
    var token: String
    
    @Option(help: "Save session to config")
    var save: Bool = false
    
    func run() async throws {
        let client = LastFMClient()
        let configManager = ConfigManager()
        
        do {
            let session = try await client.auth.getSession(token: token)
            print("\nSession created successfully!")
            print("Username: \(session.name)")
            print("Session Key: \(session.key)")
            print("Subscriber: \(session.subscriber == 1 ? "Yes" : "No")")
            
            if save {
                try configManager.saveSession(username: session.name, sessionKey: session.key)
                print("\n✓ Session saved to config")
            }
        } catch {
            print("\nFailed to get session: \(error.localizedDescription)")
        }
    }
}

struct AuthGetMobileSession: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "mobile-session",
        abstract: "Get a mobile session with username and password"
    )
    
    @Argument(help: "Username")
    var username: String
    
    @Argument(help: "Password")
    var password: String
    
    @Option(help: "Save session to config")
    var save: Bool = false
    
    func run() async throws {
        let client = LastFMClient()
        let configManager = ConfigManager()
        
        do {
            let session = try await client.auth.getMobileSession(username: username, password: password)
            print("\nMobile session created successfully!")
            print("Username: \(session.name)")
            print("Session Key: \(session.key)")
            print("Subscriber: \(session.subscriber == 1 ? "Yes" : "No")")
            
            if save {
                try configManager.saveSession(username: session.name, sessionKey: session.key)
                print("\n✓ Session saved to config")
            }
        } catch {
            print("\nFailed to get mobile session: \(error.localizedDescription)")
        }
    }
}
import ArgumentParser
import Foundation
import LastFMKit

struct MyCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "my",
        abstract: "Commands for authenticated users",
        subcommands: [
            MyInfo.self,
            MyRecentTracks.self,
            MyTopArtists.self,
            MyTopTracks.self,
            MyTopAlbums.self,
            MyTopTags.self,
            MyLovedTracks.self,
            MyFriends.self
        ]
    )
}

struct MyInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get your user information (requires authentication)"
    )
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let user = try await client.user.getInfo(user: session.username)
            
            print("\nUser: \(user.name)")
            if let realName = user.realname, !realName.isEmpty {
                print("Real Name: \(realName)")
            }
            if let country = user.country, !country.isEmpty {
                print("Country: \(country)")
            }
            if let age = user.age, let ageInt = Int(age), ageInt > 0 {
                print("Age: \(age)")
            }
            if let playcount = user.playcount?.value {
                print("Playcount: \(playcount)")
            }
            if let registered = user.registered?.text.value {
                print("Registered: \(registered)")
            }
            if let url = user.url {
                print("URL: \(url)")
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyRecentTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "recent-tracks",
        abstract: "Get your recent tracks (requires authentication)"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    @Option(help: "Include extended data")
    var extended: Bool = false
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (tracks, pagination) = try await client.user.getRecentTracks(
                user: session.username,
                limit: limit,
                page: page,
                extended: extended
            )
            
            print("\nRecent Tracks:")
            print("Total: \(pagination.total)")
            print()
            
            for (index, track) in tracks.enumerated() {
                print("\(index + 1). \(track.name) by \(track.artist.name)")
                if let album = track.album?.text {
                    print("   Album: \(album)")
                }
                if let date = track.date {
                    print("   Played: \(date.text.value)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyTopArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-artists",
        abstract: "Get your top artists (requires authentication)"
    )
    
    @Option(help: "Time period (overall, 7day, 1month, 3month, 6month, 12month)")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (artists, _) = try await client.user.getTopArtists(
                user: session.username,
                period: Period(rawValue: period) ?? .overall,
                limit: limit,
                page: page
            )
            
            print("\nTop Artists (\(period)):\n")
            
            for (index, artist) in artists.enumerated() {
                print("\(index + 1). \(artist.name)")
                if let playcount = artist.playcount?.value {
                    print("   Playcount: \(playcount)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get your top tracks (requires authentication)"
    )
    
    @Option(help: "Time period (overall, 7day, 1month, 3month, 6month, 12month)")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (tracks, _) = try await client.user.getTopTracks(
                user: session.username,
                period: Period(rawValue: period) ?? .overall,
                limit: limit,
                page: page
            )
            
            print("\nTop Tracks (\(period)):\n")
            
            for (index, track) in tracks.enumerated() {
                print("\(index + 1). \(track.name) by \(track.artist.name)")
                if let playcount = track.playcount?.value {
                    print("   Playcount: \(playcount)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyTopAlbums: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-albums",
        abstract: "Get your top albums (requires authentication)"
    )
    
    @Option(help: "Time period (overall, 7day, 1month, 3month, 6month, 12month)")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (albums, _) = try await client.user.getTopAlbums(
                user: session.username,
                period: Period(rawValue: period) ?? .overall,
                limit: limit,
                page: page
            )
            
            print("\nTop Albums (\(period)):\n")
            
            for (index, album) in albums.enumerated() {
                print("\(index + 1). \(album.name) by \(album.artist.name)")
                if let playcount = album.playcount?.value {
                    print("   Playcount: \(playcount)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get your top tags (requires authentication)"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let tags = try await client.user.getTopTags(user: session.username, limit: limit)
            
            print("\nTop Tags:\n")
            
            for (index, tag) in tags.enumerated() {
                print("\(index + 1). \(tag.name)")
                if let count = tag.count?.intValue {
                    print("   Count: \(count)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyLovedTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "loved-tracks",
        abstract: "Get your loved tracks (requires authentication)"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (tracks, pagination) = try await client.user.getLovedTracks(
                user: session.username,
                limit: limit,
                page: page
            )
            
            print("\nLoved Tracks:")
            print("Total: \(pagination.total)")
            print()
            
            for (index, track) in tracks.enumerated() {
                print("\(index + 1). \(track.name) by \(track.artist.name)")
                if let date = track.date?.text.value {
                    print("   Loved on: \(date)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}

struct MyFriends: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "friends",
        abstract: "Get your friends list (requires authentication)"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let configManager = ConfigManager()
        guard let session = configManager.getSession() else {
            print("\nError: Not authenticated. Use 'lastfm-cli auth login' first")
            return
        }
        
        let client = LastFMClient()
        do {
            let (friends, pagination) = try await client.user.getFriends(
                user: session.username,
                limit: limit,
                page: page
            )
            
            print("\nFriends:")
            print("Total: \(pagination.total)")
            print()
            
            for friend in friends {
                print("- \(friend.name)")
                if let realName = friend.realname, !realName.isEmpty {
                    print("  Real Name: \(realName)")
                }
                if let country = friend.country, !country.isEmpty {
                    print("  Country: \(country)")
                }
                print()
            }
        } catch {
            print("\nError: \(error.localizedDescription)")
        }
    }
}
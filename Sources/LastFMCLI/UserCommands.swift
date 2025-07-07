import ArgumentParser
import Foundation
import LastFMKit

struct UserCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "user",
        abstract: "User-related commands",
        subcommands: [
            UserInfo.self,
            UserRecentTracks.self,
            UserTopArtists.self,
            UserTopTracks.self,
            UserTopAlbums.self,
            UserFriends.self,
            UserLovedTracks.self,
            UserTopTags.self
        ]
    )
}

struct UserInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get user information"
    )
    
    @Argument(help: "Username")
    var user: String
    
    func run() async throws {
        let client = LastFMClient()
        let userInfo = try await client.user.getInfo(user: user)
        
        print("\nUser: \(userInfo.name)")
        if let realname = userInfo.realname, !realname.isEmpty {
            print("Real Name: \(realname)")
        }
        if let country = userInfo.country {
            print("Country: \(country)")
        }
        if let age = userInfo.age {
            print("Age: \(age)")
        }
        if let playcount = userInfo.playcount?.value {
            print("Playcount: \(playcount)")
        }
        if let registered = userInfo.registered?.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            print("Registered: \(formatter.string(from: registered))")
        }
        if let url = userInfo.url {
            print("URL: \(url)")
        }
    }
}

struct UserRecentTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "recent-tracks",
        abstract: "Get user's recent tracks"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, _) = try await client.user.getRecentTracks(user: user, limit: limit)
        
        print("\nRecent Tracks for \(user):\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name) by \(track.artist.name)")
            if let album = track.album {
                print("   Album: \(album.albumTitle)")
            }
            if let date = track.date?.date {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                print("   Played: \(formatter.string(from: date))")
            } else if track.attr?.nowplaying == "true" {
                print("   Now Playing")
            }
            print()
        }
    }
}

struct UserTopArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-artists",
        abstract: "Get user's top artists"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Time period")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let periodEnum = Period(rawValue: period) ?? .overall
        let (artists, _) = try await client.user.getTopArtists(user: user, period: periodEnum, limit: limit)
        
        print("\nTop Artists for \(user) (\(periodEnum.rawValue)):\n")
        
        for (index, artist) in artists.enumerated() {
            print("\(index + 1). \(artist.name)")
            if let playcount = artist.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct UserTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get user's top tracks"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Time period")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let periodEnum = Period(rawValue: period) ?? .overall
        let (tracks, _) = try await client.user.getTopTracks(user: user, period: periodEnum, limit: limit)
        
        print("\nTop Tracks for \(user) (\(periodEnum.rawValue)):\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name) by \(track.artist.name)")
            if let playcount = track.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct UserTopAlbums: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-albums",
        abstract: "Get user's top albums"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Time period")
    var period: String = "overall"
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let periodEnum = Period(rawValue: period) ?? .overall
        let (albums, _) = try await client.user.getTopAlbums(user: user, period: periodEnum, limit: limit)
        
        print("\nTop Albums for \(user) (\(periodEnum.rawValue)):\n")
        
        for (index, album) in albums.enumerated() {
            print("\(index + 1). \(album.name) by \(album.artist.name)")
            if let playcount = album.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct UserFriends: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "friends",
        abstract: "Get user's friends"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (friends, pagination) = try await client.user.getFriends(user: user, limit: limit)
        
        print("\nFriends of \(user):")
        print("Total: \(pagination.totalInt)\n")
        
        for friend in friends {
            print("- \(friend.name)")
            if let realname = friend.realname, !realname.isEmpty {
                print("  Real Name: \(realname)")
            }
            if let country = friend.country {
                print("  Country: \(country)")
            }
            print()
        }
    }
}

struct UserLovedTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "loved-tracks",
        abstract: "Get user's loved tracks"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, pagination) = try await client.user.getLovedTracks(user: user, limit: limit)
        
        print("\nLoved Tracks for \(user):")
        print("Total: \(pagination.totalInt)\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name) by \(track.artist.name)")
            if let date = track.date?.date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                print("   Loved on: \(formatter.string(from: date))")
            }
            print()
        }
    }
}

struct UserTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get user's top tags"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 20
    
    func run() async throws {
        let client = LastFMClient()
        let tags = try await client.user.getTopTags(user: user, limit: limit)
        
        print("\nTop Tags for \(user):\n")
        
        for (index, tag) in tags.enumerated() {
            print("\(index + 1). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            print()
        }
    }
}
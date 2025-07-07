import ArgumentParser
import Foundation
import LastFMKit

struct TrackCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "track",
        abstract: "Track-related commands",
        subcommands: [
            TrackSearch.self,
            TrackInfo.self,
            TrackSimilar.self,
            TrackTopTags.self,
            TrackCorrection.self
        ]
    )
}

struct TrackSearch: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search for tracks"
    )
    
    @Argument(help: "Track name to search for")
    var track: String
    
    @Option(help: "Artist name (optional)")
    var artist: String?
    
    @Option(name: .shortAndLong, help: "Number of results per page")
    var limit: Int = 30
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, pagination) = try await client.track.search(track: track, artist: artist, limit: limit, page: page)
        
        print("\nSearch Results for '\(track)':")
        print("Total Results: \(pagination.totalInt)")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name) by \(track.artist.name)")
            if let listeners = track.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            print()
        }
    }
}

struct TrackInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get track information"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Track name")
    var track: String
    
    @Option(help: "Include autocorrection")
    var autocorrect: Bool = false
    
    func run() async throws {
        let client = LastFMClient()
        let trackInfo = try await client.track.getInfo(artist: artist, track: track, autocorrect: autocorrect)
        
        print("\nTrack: \(trackInfo.name)")
        print("Artist: \(trackInfo.artist.name)")
        if let album = trackInfo.album {
            print("Album: \(album.albumTitle)")
        }
        if let duration = trackInfo.duration?.value {
            let seconds = (Int(duration) ?? 0) / 1000
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            print("Duration: \(minutes):\(String(format: "%02d", remainingSeconds))")
        }
        if let listeners = trackInfo.listeners?.value {
            print("Listeners: \(listeners)")
        }
        if let playcount = trackInfo.playcount?.value {
            print("Playcount: \(playcount)")
        }
        
        if let tags = trackInfo.toptags?.tag.prefix(5) {
            print("\nTop Tags:")
            for tag in tags {
                print("  - \(tag.name)")
            }
        }
    }
}

struct TrackSimilar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "similar",
        abstract: "Get similar tracks"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Track name")
    var track: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let similar = try await client.track.getSimilar(artist: artist, track: track, limit: limit)
        
        print("\nTracks similar to '\(track)' by \(artist):\n")
        
        for (index, similarTrack) in similar.enumerated() {
            print("\(index + 1). \(similarTrack.name) by \(similarTrack.artist.name)")
            if let playcount = similarTrack.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct TrackTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get top tags for a track"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Track name")
    var track: String
    
    func run() async throws {
        let client = LastFMClient()
        let tags = try await client.track.getTopTags(artist: artist, track: track)
        
        print("\nTop Tags for '\(track)' by \(artist):\n")
        
        for (index, tag) in tags.prefix(10).enumerated() {
            print("\(index + 1). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            print()
        }
    }
}

struct TrackCorrection: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "correction",
        abstract: "Get spelling correction for a track"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Track name")
    var track: String
    
    func run() async throws {
        let client = LastFMClient()
        if let correction = try await client.track.getCorrection(artist: artist, track: track) {
            print("\nCorrection found:")
            print("'\(track)' by '\(artist)' should be '\(correction.name)' by '\(correction.artist.name)'")
        } else {
            print("\nNo correction found for '\(track)' by '\(artist)'")
        }
    }
}
import ArgumentParser
import Foundation
import LastFMKit

@main
struct LastFMCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "lastfm-cli",
        abstract: "LastFM API CLI Tool",
        version: "1.0.0",
        subcommands: [
            ArtistCommand.self,
            AlbumCommand.self,
            TrackCommand.self,
            ChartCommand.self,
            GeoCommand.self,
            TagCommand.self,
            UserCommand.self,
            LibraryCommand.self,
            AuthCommand.self,
            MyCommand.self,
            ConfigCommand.self
        ]
    )
}

struct ArtistCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "artist",
        abstract: "Artist-related commands",
        subcommands: [
            ArtistSearch.self,
            ArtistInfo.self,
            ArtistTopTracks.self,
            ArtistTopAlbums.self,
            ArtistSimilar.self,
            ArtistTopTags.self,
            ArtistCorrection.self
        ]
    )
}

struct ArtistSearch: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search for artists"
    )
    
    @Argument(help: "Artist name to search for")
    var artist: String
    
    @Option(name: .shortAndLong, help: "Number of results per page")
    var limit: Int = 30
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (artists, pagination) = try await client.artist.search(artist: artist, limit: limit, page: page)
        
        print("\nSearch Results for '\(artist)':")
        print("Total Results: \(pagination.totalInt)")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, artist) in artists.enumerated() {
            print("\(index + 1). \(artist.name)")
            if let listeners = artist.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            if let url = artist.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct ArtistInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get artist information"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Option(help: "Include autocorrection")
    var autocorrect: Bool = false
    
    func run() async throws {
        let client = LastFMClient()
        let artistInfo = try await client.artist.getInfo(artist: artist, autocorrect: autocorrect)
        
        print("\nArtist: \(artistInfo.name)")
        if let url = artistInfo.url {
            print("URL: \(url)")
        }
        if let listeners = artistInfo.listeners?.value {
            print("Listeners: \(listeners)")
        }
        if let playcount = artistInfo.playcount?.value {
            print("Playcount: \(playcount)")
        }
        if let bio = artistInfo.bio?.summary {
            print("\nBiography:\n\(bio)")
        }
        if let tags = artistInfo.tags?.tag.prefix(5) {
            print("\nTop Tags:")
            for tag in tags {
                print("  - \(tag.name)")
            }
        }
    }
}

struct ArtistTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get top tracks for an artist"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, _) = try await client.artist.getTopTracks(artist: artist, limit: limit)
        
        print("\nTop \(tracks.count) Tracks for \(artist):\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name)")
            if let playcount = track.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            if let listeners = track.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            print()
        }
    }
}

struct ArtistTopAlbums: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-albums",
        abstract: "Get top albums for an artist"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (albums, _) = try await client.artist.getTopAlbums(artist: artist, limit: limit)
        
        print("\nTop \(albums.count) Albums for \(artist):\n")
        
        for (index, album) in albums.enumerated() {
            print("\(index + 1). \(album.name)")
            if let playcount = album.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct ArtistSimilar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "similar",
        abstract: "Get similar artists"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let similar = try await client.artist.getSimilar(artist: artist, limit: limit)
        
        print("\nArtists similar to \(artist):\n")
        
        for (index, similarArtist) in similar.enumerated() {
            print("\(index + 1). \(similarArtist.name)")
            if let url = similarArtist.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct ArtistTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get top tags for an artist"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    func run() async throws {
        let client = LastFMClient()
        let tags = try await client.artist.getTopTags(artist: artist)
        
        print("\nTop Tags for \(artist):\n")
        
        for (index, tag) in tags.prefix(10).enumerated() {
            print("\(index + 1). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            print()
        }
    }
}

struct ArtistCorrection: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "correction",
        abstract: "Get spelling correction for an artist"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    func run() async throws {
        let client = LastFMClient()
        if let correction = try await client.artist.getCorrection(artist: artist) {
            print("\nCorrection found:")
            print("'\(artist)' should be '\(correction.name)'")
        } else {
            print("\nNo correction found for '\(artist)'")
        }
    }
}
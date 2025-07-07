import ArgumentParser
import Foundation
import LastFMKit

struct AlbumCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "album",
        abstract: "Album-related commands",
        subcommands: [
            AlbumSearch.self,
            AlbumInfo.self,
            AlbumTopTags.self
        ]
    )
}

struct AlbumSearch: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search for albums"
    )
    
    @Argument(help: "Album name to search for")
    var album: String
    
    @Option(name: .shortAndLong, help: "Number of results per page")
    var limit: Int = 30
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (albums, pagination) = try await client.album.search(album: album, limit: limit, page: page)
        
        print("\nSearch Results for '\(album)':")
        print("Total Results: \(pagination.totalInt)")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, album) in albums.enumerated() {
            print("\(index + 1). \(album.name) by \(album.artist.name)")
            if let url = album.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct AlbumInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get album information"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Album name")
    var album: String
    
    @Option(help: "Include autocorrection")
    var autocorrect: Bool = false
    
    func run() async throws {
        let client = LastFMClient()
        let albumInfo = try await client.album.getInfo(artist: artist, album: album, autocorrect: autocorrect)
        
        print("\nAlbum: \(albumInfo.name)")
        print("Artist: \(albumInfo.artist.name)")
        if let url = albumInfo.url {
            print("URL: \(url)")
        }
        if let listeners = albumInfo.listeners?.value {
            print("Listeners: \(listeners)")
        }
        if let playcount = albumInfo.playcount?.value {
            print("Playcount: \(playcount)")
        }
        
        if let tracks = albumInfo.tracks?.track {
            print("\nTracklist:")
            for (index, track) in tracks.enumerated() {
                print("\(index + 1). \(track.name)")
                if let duration = track.duration?.value {
                    let totalSeconds = Int(duration) ?? 0
                    let minutes = totalSeconds / 60
                    let seconds = totalSeconds % 60
                    print("   Duration: \(minutes):\(String(format: "%02d", seconds))")
                }
            }
        }
        
        if let tags = albumInfo.tags?.tag.prefix(5) {
            print("\nTop Tags:")
            for tag in tags {
                print("  - \(tag.name)")
            }
        }
    }
}

struct AlbumTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get top tags for an album"
    )
    
    @Argument(help: "Artist name")
    var artist: String
    
    @Argument(help: "Album name")
    var album: String
    
    func run() async throws {
        let client = LastFMClient()
        let tags = try await client.album.getTopTags(artist: artist, album: album)
        
        print("\nTop Tags for '\(album)' by \(artist):\n")
        
        for (index, tag) in tags.prefix(10).enumerated() {
            print("\(index + 1). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            print()
        }
    }
}
import ArgumentParser
import Foundation
import LastFMKit

struct TagCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "tag",
        abstract: "Tag-related commands",
        subcommands: [
            TagInfo.self,
            TagTopArtists.self,
            TagTopAlbums.self,
            TagTopTracks.self,
            TagTopTags.self,
            TagSimilar.self
        ]
    )
}

struct TagInfo: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "info",
        abstract: "Get tag information"
    )
    
    @Argument(help: "Tag name")
    var tag: String
    
    func run() async throws {
        let client = LastFMClient()
        let tagInfo = try await client.tag.getInfo(tag: tag)
        
        print("\nTag: \(tagInfo.name)")
        if let url = tagInfo.url {
            print("URL: \(url)")
        }
        if let reach = tagInfo.reach?.intValue {
            print("Reach: \(reach)")
        }
        if let taggings = tagInfo.taggings?.intValue {
            print("Taggings: \(taggings)")
        }
        
        if let wiki = tagInfo.wiki?.summary {
            print("\nDescription:\n\(wiki)")
        }
    }
}

struct TagTopArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-artists",
        abstract: "Get top artists for a tag"
    )
    
    @Argument(help: "Tag name")
    var tag: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (artists, _) = try await client.tag.getTopArtists(tag: tag, limit: limit)
        
        print("\nTop Artists for tag '\(tag)':\n")
        
        for (index, artist) in artists.enumerated() {
            print("\(index + 1). \(artist.name)")
            if let url = artist.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct TagTopAlbums: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-albums",
        abstract: "Get top albums for a tag"
    )
    
    @Argument(help: "Tag name")
    var tag: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (albums, _) = try await client.tag.getTopAlbums(tag: tag, limit: limit)
        
        print("\nTop Albums for tag '\(tag)':\n")
        
        for (index, album) in albums.enumerated() {
            print("\(index + 1). \(album.name) by \(album.artist.name)")
            if let url = album.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct TagTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get top tracks for a tag"
    )
    
    @Argument(help: "Tag name")
    var tag: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, _) = try await client.tag.getTopTracks(tag: tag, limit: limit)
        
        print("\nTop Tracks for tag '\(tag)':\n")
        
        for (index, track) in tracks.enumerated() {
            print("\(index + 1). \(track.name) by \(track.artist.name)")
            if let url = track.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}

struct TagTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get global top tags"
    )
    
    func run() async throws {
        let client = LastFMClient()
        let tags = try await client.tag.getTopTags()
        
        print("\nGlobal Top Tags:\n")
        
        for (index, tag) in tags.prefix(20).enumerated() {
            print("\(index + 1). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            print()
        }
    }
}

struct TagSimilar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "similar",
        abstract: "Get similar tags"
    )
    
    @Argument(help: "Tag name")
    var tag: String
    
    func run() async throws {
        let client = LastFMClient()
        let similar = try await client.tag.getSimilar(tag: tag)
        
        print("\nTags similar to '\(tag)':\n")
        
        for (index, similarTag) in similar.enumerated() {
            print("\(index + 1). \(similarTag.name)")
            if let url = similarTag.url {
                print("   URL: \(url)")
            }
            print()
        }
    }
}
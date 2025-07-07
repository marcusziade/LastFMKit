import ArgumentParser
import Foundation
import LastFMKit

struct ChartCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "chart",
        abstract: "Chart-related commands",
        subcommands: [
            ChartTopArtists.self,
            ChartTopTracks.self,
            ChartTopTags.self
        ]
    )
}

struct ChartTopArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-artists",
        abstract: "Get top artists chart"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (artists, pagination) = try await client.chart.getTopArtists(page: page, limit: limit)
        
        print("\nTop Artists Chart:")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, artist) in artists.enumerated() {
            let rank = (pagination.pageInt - 1) * pagination.perPageInt + index + 1
            print("\(rank). \(artist.name)")
            if let listeners = artist.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            if let playcount = artist.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct ChartTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get top tracks chart"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, pagination) = try await client.chart.getTopTracks(page: page, limit: limit)
        
        print("\nTop Tracks Chart:")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, track) in tracks.enumerated() {
            let rank = (pagination.pageInt - 1) * pagination.perPageInt + index + 1
            print("\(rank). \(track.name) by \(track.artist.name)")
            if let listeners = track.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            if let playcount = track.playcount?.value {
                print("   Playcount: \(playcount)")
            }
            print()
        }
    }
}

struct ChartTopTags: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tags",
        abstract: "Get top tags chart"
    )
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (tags, pagination) = try await client.chart.getTopTags(page: page, limit: limit)
        
        print("\nTop Tags Chart:")
        print("Page \(pagination.pageInt) of \(pagination.totalPagesInt)\n")
        
        for (index, tag) in tags.enumerated() {
            let rank = (pagination.pageInt - 1) * pagination.perPageInt + index + 1
            print("\(rank). \(tag.name)")
            if let count = tag.count?.intValue {
                print("   Count: \(count)")
            }
            if let reach = tag.reach?.intValue {
                print("   Reach: \(reach)")
            }
            print()
        }
    }
}
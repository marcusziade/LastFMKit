import ArgumentParser
import Foundation
import LastFMKit

struct GeoCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "geo",
        abstract: "Geographic-related commands",
        subcommands: [
            GeoTopArtists.self,
            GeoTopTracks.self
        ]
    )
}

struct GeoTopArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-artists",
        abstract: "Get top artists by country"
    )
    
    @Argument(help: "Country name (ISO 3166-1)")
    var country: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (artists, attributes) = try await client.geo.getTopArtists(country: country, page: page, limit: limit)
        
        print("\nTop Artists in \(country):")
        print("Page \(attributes.page) of \(attributes.totalPages)\n")
        
        for (index, artist) in artists.enumerated() {
            let pageNum = Int(attributes.page) ?? 1
            let perPage = Int(attributes.perPage) ?? 50
            let rank = (pageNum - 1) * perPage + index + 1
            print("\(rank). \(artist.name)")
            if let listeners = artist.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            print()
        }
    }
}

struct GeoTopTracks: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "top-tracks",
        abstract: "Get top tracks by country"
    )
    
    @Argument(help: "Country name (ISO 3166-1)")
    var country: String
    
    @Option(name: .shortAndLong, help: "Number of results")
    var limit: Int = 10
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (tracks, attributes) = try await client.geo.getTopTracks(country: country, page: page, limit: limit)
        
        print("\nTop Tracks in \(country):")
        print("Page \(attributes.page) of \(attributes.totalPages)\n")
        
        for (index, track) in tracks.enumerated() {
            let pageNum = Int(attributes.page) ?? 1
            let perPage = Int(attributes.perPage) ?? 50
            let rank = (pageNum - 1) * perPage + index + 1
            print("\(rank). \(track.name) by \(track.artist.name)")
            if let listeners = track.listeners?.value {
                print("   Listeners: \(listeners)")
            }
            print()
        }
    }
}
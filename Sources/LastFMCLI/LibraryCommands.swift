import ArgumentParser
import Foundation
import LastFMKit

struct LibraryCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "library",
        abstract: "Library-related commands",
        subcommands: [
            LibraryArtists.self
        ]
    )
}

struct LibraryArtists: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "artists",
        abstract: "Get artists in a user's library"
    )
    
    @Argument(help: "Username")
    var user: String
    
    @Option(name: .shortAndLong, help: "Number of results per page")
    var limit: Int = 50
    
    @Option(name: .shortAndLong, help: "Page number")
    var page: Int = 1
    
    func run() async throws {
        let client = LastFMClient()
        let (artists, attributes) = try await client.library.getArtists(user: user, limit: limit, page: page)
        
        print("\nArtists in \(user)'s Library:")
        print("Total: \(attributes.total)")
        print("Page \(attributes.page) of \(attributes.totalPages)\n")
        
        for artist in artists {
            print("- \(artist.name)")
            if let playcount = artist.playcount?.value {
                print("  Playcount: \(playcount)")
            }
            if let url = artist.url {
                print("  URL: \(url)")
            }
            print()
        }
    }
}
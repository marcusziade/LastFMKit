import Foundation

public struct LibraryArtistsResponse: Codable {
    public let artists: LibraryArtists
}

public struct LibraryArtists: Codable {
    public let artist: [Artist]
    public let attr: LibraryAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct LibraryAttributes: Codable {
    public let user: String
    public let totalPages: String
    public let page: String
    public let perPage: String
    public let total: String
}
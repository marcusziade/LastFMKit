import Foundation

public struct GeoTopArtistsResponse: Codable {
    public let topartists: GeoArtists
}

public struct GeoArtists: Codable {
    public let artist: [Artist]
    public let attr: GeoAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct GeoTopTracksResponse: Codable {
    public let tracks: GeoTracks
}

public struct GeoTracks: Codable {
    public let track: [Track]
    public let attr: GeoAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct GeoAttributes: Codable {
    public let country: String
    public let page: String
    public let perPage: String
    public let totalPages: String
    public let total: String
}
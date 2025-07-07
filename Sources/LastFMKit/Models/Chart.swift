import Foundation

public struct ChartTopArtistsResponse: Codable {
    public let artists: ChartArtists
}

public struct ChartArtists: Codable {
    public let artist: [Artist]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct ChartTopTracksResponse: Codable {
    public let tracks: ChartTracks
}

public struct ChartTracks: Codable {
    public let track: [Track]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct ChartTopTagsResponse: Codable {
    public let tags: ChartTags
}

public struct ChartTags: Codable {
    public let tag: [Tag]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case tag
        case attr = "@attr"
    }
}
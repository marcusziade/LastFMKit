import Foundation

public struct Album: Codable {
    public let name: String
    public let artist: AlbumArtist
    public let mbid: String?
    public let url: String?
    public let image: [LastFMImage]?
    public let listeners: StringOrInt?
    public let playcount: StringOrInt?
    public let tracks: AlbumTracks?
    public let tags: AlbumTags?
    public let wiki: Wiki?
    public let userplaycount: StringOrInt?
}

public enum AlbumArtist: Codable {
    case string(String)
    case object(Artist)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let artist = try? container.decode(Artist.self) {
            self = .object(artist)
        } else {
            throw DecodingError.typeMismatch(AlbumArtist.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Artist object"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .object(let artist):
            try container.encode(artist)
        }
    }
    
    public var name: String {
        switch self {
        case .string(let name):
            return name
        case .object(let artist):
            return artist.name
        }
    }
}

public struct AlbumTracks: Codable {
    public let track: [Track]
}

public struct AlbumTags: Codable {
    public let tag: [Tag]
}

public struct AlbumInfoResponse: Codable {
    public let album: Album
}

public struct AlbumSearchResponse: Codable {
    public let results: AlbumSearchResults
}

public struct AlbumSearchResults: Codable {
    public let albummatches: AlbumMatches
    public let totalResults: String
    public let startIndex: String
    public let itemsPerPage: String
    
    private enum CodingKeys: String, CodingKey {
        case albummatches
        case totalResults = "opensearch:totalResults"
        case startIndex = "opensearch:startIndex"
        case itemsPerPage = "opensearch:itemsPerPage"
    }
    
    public var paginationAttributes: PaginationAttributes {
        let currentPage = (Int(startIndex) ?? 0) / (Int(itemsPerPage) ?? 30) + 1
        let totalPages = ((Int(totalResults) ?? 0) + (Int(itemsPerPage) ?? 30) - 1) / (Int(itemsPerPage) ?? 30)
        
        return PaginationAttributes(
            page: String(currentPage),
            perPage: itemsPerPage,
            total: totalResults,
            totalPages: String(totalPages)
        )
    }
}

public struct AlbumMatches: Codable {
    public let album: [Album]
}

public struct AlbumTopTagsResponse: Codable {
    public let toptags: TopTags
}
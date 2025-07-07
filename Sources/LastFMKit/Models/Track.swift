import Foundation

public struct Track: Codable {
    public let name: String
    public let artist: TrackArtist
    public let mbid: String?
    public let url: String?
    public let duration: StringOrInt?
    public let streamable: StreamableValue?
    public let listeners: StringOrInt?
    public let playcount: StringOrInt?
    public let userplaycount: StringOrInt?
    public let userloved: StringOrInt?
    public let toptags: TrackTags?
    public let wiki: Wiki?
    public let album: TrackAlbum?
    public let image: [LastFMImage]?
    public let date: DateInfo?
    public let attr: TrackAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case name, artist, mbid, url, duration, streamable, listeners, playcount
        case userplaycount, userloved, toptags, wiki, album, image, date
        case attr = "@attr"
    }
}

public struct SimpleArtist: Codable {
    public let text: String
    public let mbid: String?
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case mbid
    }
}

public enum TrackArtist: Codable {
    case string(String)
    case object(Artist)
    case simple(SimpleArtist)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let artist = try? container.decode(Artist.self) {
            self = .object(artist)
        } else if let simple = try? container.decode(SimpleArtist.self) {
            self = .simple(simple)
        } else {
            throw DecodingError.typeMismatch(TrackArtist.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String, Artist object, or SimpleArtist"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .object(let artist):
            try container.encode(artist)
        case .simple(let artist):
            try container.encode(artist)
        }
    }
    
    public var name: String {
        switch self {
        case .string(let name):
            return name
        case .object(let artist):
            return artist.name
        case .simple(let artist):
            return artist.text
        }
    }
}

public struct TrackAlbum: Codable {
    public let artist: String?
    public let title: String?
    public let mbid: String?
    public let url: String?
    public let text: String?
    
    private enum CodingKeys: String, CodingKey {
        case artist, title, mbid, url
        case text = "#text"
    }
    
    public var albumTitle: String {
        return title ?? text ?? ""
    }
}

public struct TrackTags: Codable {
    public let tag: [Tag]
}

public struct TrackAttributes: Codable {
    public let nowplaying: String?
}

public struct TrackInfoResponse: Codable {
    public let track: Track
}

public struct TrackSearchResponse: Codable {
    public let results: TrackSearchResults
}

public struct TrackSearchResults: Codable {
    public let trackmatches: TrackMatches
    public let totalResults: String
    public let startIndex: String
    public let itemsPerPage: String
    
    private enum CodingKeys: String, CodingKey {
        case trackmatches
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

public struct TrackMatches: Codable {
    public let track: [Track]
}

public struct TrackCorrectionResponse: Codable {
    public let corrections: TrackCorrections
}

public struct TrackCorrections: Codable {
    public let correction: TrackCorrection?
}

public struct TrackCorrection: Codable {
    public let track: Track
}

public struct TrackSimilarResponse: Codable {
    public let similartracks: SimilarTracks
}

public struct SimilarTracks: Codable {
    public let track: [Track]
    public let attr: SimilarTracksAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct SimilarTracksAttributes: Codable {
    public let artist: String
}

public struct TrackTopTagsResponse: Codable {
    public let toptags: TopTags
}
import Foundation

public struct Artist: Codable {
    public let name: String
    public let mbid: String?
    public let url: String?
    public let image: [LastFMImage]?
    public let streamable: StringOrInt?
    public let listeners: StringOrInt?
    public let playcount: StringOrInt?
    public let bio: Wiki?
    public let similar: SimilarArtists?
    public let tags: ArtistTags?
    public let stats: ArtistStats?
    
    public struct SimilarArtists: Codable {
        public let artist: [Artist]
    }
    
    public struct ArtistTags: Codable {
        public let tag: [Tag]
    }
    
    public struct ArtistStats: Codable {
        public let listeners: StringOrInt
        public let playcount: StringOrInt
        public let userplaycount: StringOrInt?
    }
}

public struct ArtistSearchResponse: Codable {
    public let results: ArtistSearchResults
}

public struct ArtistSearchResults: Codable {
    public let artistmatches: ArtistMatches
    public let totalResults: String
    public let startIndex: String
    public let itemsPerPage: String
    
    private enum CodingKeys: String, CodingKey {
        case artistmatches
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

public struct ArtistMatches: Codable {
    public let artist: [Artist]
}

public struct ArtistInfoResponse: Codable {
    public let artist: Artist
}

public struct ArtistCorrectionResponse: Codable {
    public let corrections: ArtistCorrections
}

public struct ArtistCorrections: Codable {
    public let correction: ArtistCorrection?
}

public struct ArtistCorrection: Codable {
    public let artist: Artist
}

public struct ArtistTopAlbumsResponse: Codable {
    public let topalbums: TopAlbums
}

public struct TopAlbums: Codable {
    public let album: [Album]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}

public struct ArtistTopTracksResponse: Codable {
    public let toptracks: TopTracks
}

public struct TopTracks: Codable {
    public let track: [Track]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct ArtistSimilarResponse: Codable {
    public let similarartists: SimilarArtistsResponse
}

public struct SimilarArtistsResponse: Codable {
    public let artist: [Artist]
    public let attr: SimilarArtistsAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct SimilarArtistsAttributes: Codable {
    public let artist: String
}

public struct ArtistTopTagsResponse: Codable {
    public let toptags: TopTags
}

public struct TopTags: Codable {
    public let tag: [Tag]
    public let attr: TopTagsAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case tag
        case attr = "@attr"
    }
}

public struct TopTagsAttributes: Codable {
    public let artist: String?
    public let album: String?
    public let track: String?
}
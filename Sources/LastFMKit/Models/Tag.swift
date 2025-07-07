import Foundation

public struct Tag: Codable {
    public let name: String
    public let url: String?
    public let count: StringOrInt?
    public let reach: StringOrInt?
    public let taggings: StringOrInt?
    public let streamable: String?
    public let wiki: Wiki?
}

public struct TagInfoResponse: Codable {
    public let tag: Tag
}

public struct TagSimilarResponse: Codable {
    public let similartags: SimilarTags
}

public struct SimilarTags: Codable {
    public let tag: [Tag]
}

public struct TagTopAlbumsResponse: Codable {
    public let albums: TagAlbums
}

public struct TagAlbums: Codable {
    public let album: [Album]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}

public struct TagTopArtistsResponse: Codable {
    public let topartists: TagArtists
}

public struct TagArtists: Codable {
    public let artist: [Artist]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct TagTopTracksResponse: Codable {
    public let tracks: TagTracks
}

public struct TagTracks: Codable {
    public let track: [Track]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct TagTopTagsResponse: Codable {
    public let toptags: GlobalTopTags
}

public struct GlobalTopTags: Codable {
    public let tag: [Tag]
}

public struct TagWeeklyChartListResponse: Codable {
    public let weeklychartlist: WeeklyChartList
}

public struct WeeklyChartList: Codable {
    public let chart: [ChartPeriod]
    public let attr: WeeklyChartAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case chart
        case attr = "@attr"
    }
}

public struct ChartPeriod: Codable {
    public let from: String
    public let to: String
    
    private enum CodingKeys: String, CodingKey {
        case from = "#text"
        case to
    }
}

public struct WeeklyChartAttributes: Codable {
    public let tag: String?
    public let user: String?
}
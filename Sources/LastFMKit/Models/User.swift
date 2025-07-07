import Foundation

public struct User: Codable {
    public let name: String
    public let realname: String?
    public let url: String?
    public let image: [LastFMImage]?
    public let country: String?
    public let age: String?
    public let gender: String?
    public let playcount: StringOrInt?
    public let playlists: StringOrInt?
    public let bootstrap: StringOrInt?
    public let registered: DateInfo?
    public let type: String?
    public let subscriber: StringOrInt?
}

public struct UserInfoResponse: Codable {
    public let user: User
}

public struct UserFriendsResponse: Codable {
    public let friends: UserFriends
}

public struct UserFriends: Codable {
    public let user: [User]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case user
        case attr = "@attr"
    }
}

public struct UserLovedTracksResponse: Codable {
    public let lovedtracks: LovedTracks
}

public struct LovedTracks: Codable {
    public let track: [Track]
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct UserRecentTracksResponse: Codable {
    public let recenttracks: RecentTracks
}

public struct RecentTracks: Codable {
    public let track: [Track]
    public let attr: RecentTracksAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct RecentTracksAttributes: Codable {
    public let user: String
    public let totalPages: String
    public let page: String
    public let perPage: String
    public let total: String
}

public struct UserTopAlbumsResponse: Codable {
    public let topalbums: UserTopAlbums
}

public struct UserTopAlbums: Codable {
    public let album: [Album]
    public let attr: UserTopAttributes
    
    private enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}

public struct UserTopArtistsResponse: Codable {
    public let topartists: UserTopArtists
}

public struct UserTopArtists: Codable {
    public let artist: [Artist]
    public let attr: UserTopAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct UserTopTracksResponse: Codable {
    public let toptracks: UserTopTracks
}

public struct UserTopTracks: Codable {
    public let track: [Track]
    public let attr: UserTopAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct UserTopAttributes: Codable {
    public let user: String
    public let totalPages: String
    public let page: String
    public let perPage: String
    public let total: String
    public let period: String?
}

public struct UserTopTagsResponse: Codable {
    public let toptags: UserTopTags
}

public struct UserTopTags: Codable {
    public let tag: [Tag]
    public let attr: UserTopTagsAttributes?
    
    private enum CodingKeys: String, CodingKey {
        case tag
        case attr = "@attr"
    }
}

public struct UserTopTagsAttributes: Codable {
    public let user: String
}

public struct UserPersonalTagsResponse: Codable {
    public let taggings: PersonalTags
}

public struct PersonalTags: Codable {
    public let artists: PersonalTagArtists?
    public let albums: PersonalTagAlbums?
    public let tracks: PersonalTagTracks?
    public let attr: PaginationAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artists, albums, tracks
        case attr = "@attr"
    }
}

public struct PersonalTagArtists: Codable {
    public let artist: [Artist]
}

public struct PersonalTagAlbums: Codable {
    public let album: [Album]
}

public struct PersonalTagTracks: Codable {
    public let track: [Track]
}

public struct UserWeeklyChartListResponse: Codable {
    public let weeklychartlist: WeeklyChartList
}

public struct UserWeeklyAlbumChartResponse: Codable {
    public let weeklyalbumchart: WeeklyAlbumChart
}

public struct WeeklyAlbumChart: Codable {
    public let album: [WeeklyAlbum]
    public let attr: WeeklyChartPeriodAttributes
    
    private enum CodingKeys: String, CodingKey {
        case album
        case attr = "@attr"
    }
}

public struct WeeklyAlbum: Codable {
    public let artist: AlbumArtist
    public let name: String
    public let mbid: String?
    public let playcount: StringOrInt
    public let url: String
}

public struct UserWeeklyArtistChartResponse: Codable {
    public let weeklyartistchart: WeeklyArtistChart
}

public struct WeeklyArtistChart: Codable {
    public let artist: [WeeklyArtist]
    public let attr: WeeklyChartPeriodAttributes
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

public struct WeeklyArtist: Codable {
    public let name: String
    public let mbid: String?
    public let playcount: StringOrInt
    public let url: String
}

public struct UserWeeklyTrackChartResponse: Codable {
    public let weeklytrackchart: WeeklyTrackChart
}

public struct WeeklyTrackChart: Codable {
    public let track: [WeeklyTrack]
    public let attr: WeeklyChartPeriodAttributes
    
    private enum CodingKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }
}

public struct WeeklyTrack: Codable {
    public let artist: TrackArtist
    public let name: String
    public let mbid: String?
    public let playcount: StringOrInt
    public let url: String
}

public struct WeeklyChartPeriodAttributes: Codable {
    public let from: String
    public let to: String
    public let user: String
}
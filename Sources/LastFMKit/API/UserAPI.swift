import Foundation

public final class UserAPI: BaseAPI {
    
    public func getFriends(
        user: String,
        recenttracks: Bool = false,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (users: [User], pagination: PaginationAttributes) {
        var parameters = [
            "user": user,
            "limit": String(limit),
            "page": String(page)
        ]
        
        if recenttracks { parameters["recenttracks"] = "1" }
        
        let endpoint = buildEndpoint(category: "user", method: "getFriends", parameters: parameters)
        let response: UserFriendsResponse = try await networkClient.request(endpoint)
        return (response.friends.user, response.friends.attr)
    }
    
    public func getInfo(user: String? = nil) async throws -> User {
        var parameters: [String: String] = [:]
        if let user = user { parameters["user"] = user }
        
        let endpoint = buildEndpoint(category: "user", method: "getInfo", parameters: parameters)
        let response: UserInfoResponse = try await networkClient.request(endpoint)
        return response.user
    }
    
    public func getLovedTracks(
        user: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (tracks: [Track], pagination: PaginationAttributes) {
        let parameters = [
            "user": user,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getLovedTracks", parameters: parameters)
        let response: UserLovedTracksResponse = try await networkClient.request(endpoint)
        return (response.lovedtracks.track, response.lovedtracks.attr)
    }
    
    public func getPersonalTags(
        user: String,
        tag: String,
        taggingtype: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> PersonalTags {
        let parameters = [
            "user": user,
            "tag": tag,
            "taggingtype": taggingtype,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getPersonalTags", parameters: parameters)
        let response: UserPersonalTagsResponse = try await networkClient.request(endpoint)
        return response.taggings
    }
    
    public func getRecentTracks(
        user: String,
        limit: Int = 50,
        page: Int = 1,
        from: Int? = nil,
        extended: Bool = false,
        to: Int? = nil
    ) async throws -> (tracks: [Track], attributes: RecentTracksAttributes) {
        var parameters = [
            "user": user,
            "limit": String(limit),
            "page": String(page)
        ]
        
        if let from = from { parameters["from"] = String(from) }
        if extended { parameters["extended"] = "1" }
        if let to = to { parameters["to"] = String(to) }
        
        let endpoint = buildEndpoint(category: "user", method: "getRecentTracks", parameters: parameters)
        let response: UserRecentTracksResponse = try await networkClient.request(endpoint)
        return (response.recenttracks.track, response.recenttracks.attr)
    }
    
    public func getTopAlbums(
        user: String,
        period: Period = .overall,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (albums: [Album], attributes: UserTopAttributes) {
        let parameters = [
            "user": user,
            "period": period.rawValue,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getTopAlbums", parameters: parameters)
        let response: UserTopAlbumsResponse = try await networkClient.request(endpoint)
        return (response.topalbums.album, response.topalbums.attr)
    }
    
    public func getTopArtists(
        user: String,
        period: Period = .overall,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (artists: [Artist], attributes: UserTopAttributes) {
        let parameters = [
            "user": user,
            "period": period.rawValue,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getTopArtists", parameters: parameters)
        let response: UserTopArtistsResponse = try await networkClient.request(endpoint)
        return (response.topartists.artist, response.topartists.attr)
    }
    
    public func getTopTags(
        user: String,
        limit: Int = 50
    ) async throws -> [Tag] {
        let parameters = [
            "user": user,
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getTopTags", parameters: parameters)
        let response: UserTopTagsResponse = try await networkClient.request(endpoint)
        return response.toptags.tag
    }
    
    public func getTopTracks(
        user: String,
        period: Period = .overall,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (tracks: [Track], attributes: UserTopAttributes) {
        let parameters = [
            "user": user,
            "period": period.rawValue,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "user", method: "getTopTracks", parameters: parameters)
        let response: UserTopTracksResponse = try await networkClient.request(endpoint)
        return (response.toptracks.track, response.toptracks.attr)
    }
    
    public func getWeeklyAlbumChart(
        user: String,
        from: Int? = nil,
        to: Int? = nil
    ) async throws -> (albums: [WeeklyAlbum], attributes: WeeklyChartPeriodAttributes) {
        var parameters = ["user": user]
        if let from = from { parameters["from"] = String(from) }
        if let to = to { parameters["to"] = String(to) }
        
        let endpoint = buildEndpoint(category: "user", method: "getWeeklyAlbumChart", parameters: parameters)
        let response: UserWeeklyAlbumChartResponse = try await networkClient.request(endpoint)
        return (response.weeklyalbumchart.album, response.weeklyalbumchart.attr)
    }
    
    public func getWeeklyArtistChart(
        user: String,
        from: Int? = nil,
        to: Int? = nil
    ) async throws -> (artists: [WeeklyArtist], attributes: WeeklyChartPeriodAttributes) {
        var parameters = ["user": user]
        if let from = from { parameters["from"] = String(from) }
        if let to = to { parameters["to"] = String(to) }
        
        let endpoint = buildEndpoint(category: "user", method: "getWeeklyArtistChart", parameters: parameters)
        let response: UserWeeklyArtistChartResponse = try await networkClient.request(endpoint)
        return (response.weeklyartistchart.artist, response.weeklyartistchart.attr)
    }
    
    public func getWeeklyChartList(user: String) async throws -> [ChartPeriod] {
        let parameters = ["user": user]
        
        let endpoint = buildEndpoint(category: "user", method: "getWeeklyChartList", parameters: parameters)
        let response: UserWeeklyChartListResponse = try await networkClient.request(endpoint)
        return response.weeklychartlist.chart
    }
    
    public func getWeeklyTrackChart(
        user: String,
        from: Int? = nil,
        to: Int? = nil
    ) async throws -> (tracks: [WeeklyTrack], attributes: WeeklyChartPeriodAttributes) {
        var parameters = ["user": user]
        if let from = from { parameters["from"] = String(from) }
        if let to = to { parameters["to"] = String(to) }
        
        let endpoint = buildEndpoint(category: "user", method: "getWeeklyTrackChart", parameters: parameters)
        let response: UserWeeklyTrackChartResponse = try await networkClient.request(endpoint)
        return (response.weeklytrackchart.track, response.weeklytrackchart.attr)
    }
}
import Foundation

public final class TagAPI: BaseAPI {
    
    public func getInfo(
        tag: String,
        lang: String? = nil
    ) async throws -> Tag {
        var parameters = ["tag": tag]
        if let lang = lang { parameters["lang"] = lang }
        
        let endpoint = buildEndpoint(category: "tag", method: "getInfo", parameters: parameters)
        let response: TagInfoResponse = try await networkClient.request(endpoint)
        return response.tag
    }
    
    public func getSimilar(tag: String) async throws -> [Tag] {
        let parameters = ["tag": tag]
        
        let endpoint = buildEndpoint(category: "tag", method: "getSimilar", parameters: parameters)
        let response: TagSimilarResponse = try await networkClient.request(endpoint)
        return response.similartags.tag
    }
    
    public func getTopAlbums(
        tag: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (albums: [Album], pagination: PaginationAttributes) {
        let parameters = [
            "tag": tag,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "tag", method: "getTopAlbums", parameters: parameters)
        let response: TagTopAlbumsResponse = try await networkClient.request(endpoint)
        return (response.albums.album, response.albums.attr)
    }
    
    public func getTopArtists(
        tag: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (artists: [Artist], pagination: PaginationAttributes) {
        let parameters = [
            "tag": tag,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "tag", method: "getTopArtists", parameters: parameters)
        let response: TagTopArtistsResponse = try await networkClient.request(endpoint)
        return (response.topartists.artist, response.topartists.attr)
    }
    
    public func getTopTags() async throws -> [Tag] {
        let endpoint = buildEndpoint(category: "tag", method: "getTopTags")
        let response: TagTopTagsResponse = try await networkClient.request(endpoint)
        return response.toptags.tag
    }
    
    public func getTopTracks(
        tag: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (tracks: [Track], pagination: PaginationAttributes) {
        let parameters = [
            "tag": tag,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "tag", method: "getTopTracks", parameters: parameters)
        let response: TagTopTracksResponse = try await networkClient.request(endpoint)
        return (response.tracks.track, response.tracks.attr)
    }
    
    public func getWeeklyChartList(tag: String) async throws -> [ChartPeriod] {
        let parameters = ["tag": tag]
        
        let endpoint = buildEndpoint(category: "tag", method: "getWeeklyChartList", parameters: parameters)
        let response: TagWeeklyChartListResponse = try await networkClient.request(endpoint)
        return response.weeklychartlist.chart
    }
}
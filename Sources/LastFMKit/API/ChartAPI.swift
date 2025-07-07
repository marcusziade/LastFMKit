import Foundation

public final class ChartAPI: BaseAPI {
    
    public func getTopArtists(
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (artists: [Artist], pagination: PaginationAttributes) {
        let parameters = [
            "page": String(page),
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "chart", method: "getTopArtists", parameters: parameters)
        let response: ChartTopArtistsResponse = try await networkClient.request(endpoint)
        return (response.artists.artist, response.artists.attr)
    }
    
    public func getTopTags(
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (tags: [Tag], pagination: PaginationAttributes) {
        let parameters = [
            "page": String(page),
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "chart", method: "getTopTags", parameters: parameters)
        let response: ChartTopTagsResponse = try await networkClient.request(endpoint)
        return (response.tags.tag, response.tags.attr)
    }
    
    public func getTopTracks(
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (tracks: [Track], pagination: PaginationAttributes) {
        let parameters = [
            "page": String(page),
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "chart", method: "getTopTracks", parameters: parameters)
        let response: ChartTopTracksResponse = try await networkClient.request(endpoint)
        return (response.tracks.track, response.tracks.attr)
    }
}
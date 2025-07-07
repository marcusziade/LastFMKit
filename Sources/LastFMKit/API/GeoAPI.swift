import Foundation

public final class GeoAPI: BaseAPI {
    
    public func getTopArtists(
        country: String,
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (artists: [Artist], attributes: GeoAttributes) {
        let parameters = [
            "country": country,
            "page": String(page),
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "geo", method: "getTopArtists", parameters: parameters)
        let response: GeoTopArtistsResponse = try await networkClient.request(endpoint)
        return (response.topartists.artist, response.topartists.attr)
    }
    
    public func getTopTracks(
        country: String,
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (tracks: [Track], attributes: GeoAttributes) {
        let parameters = [
            "country": country,
            "page": String(page),
            "limit": String(limit)
        ]
        
        let endpoint = buildEndpoint(category: "geo", method: "getTopTracks", parameters: parameters)
        let response: GeoTopTracksResponse = try await networkClient.request(endpoint)
        return (response.tracks.track, response.tracks.attr)
    }
}
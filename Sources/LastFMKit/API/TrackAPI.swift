import Foundation

public final class TrackAPI: BaseAPI {
    
    public func getCorrection(artist: String, track: String) async throws -> Track? {
        let parameters = [
            "artist": artist,
            "track": track
        ]
        
        let endpoint = buildEndpoint(category: "track", method: "getCorrection", parameters: parameters)
        let response: TrackCorrectionResponse = try await networkClient.request(endpoint)
        return response.corrections.correction?.track
    }
    
    public func getInfo(
        artist: String? = nil,
        track: String? = nil,
        mbid: String? = nil,
        username: String? = nil,
        autocorrect: Bool = false
    ) async throws -> Track {
        guard (artist != nil && track != nil) || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist and track or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let track = track { parameters["track"] = track }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if let username = username { parameters["username"] = username }
        if autocorrect { parameters["autocorrect"] = "1" }
        
        let endpoint = buildEndpoint(category: "track", method: "getInfo", parameters: parameters)
        let response: TrackInfoResponse = try await networkClient.request(endpoint)
        return response.track
    }
    
    public func getSimilar(
        artist: String? = nil,
        track: String? = nil,
        mbid: String? = nil,
        autocorrect: Bool = false,
        limit: Int = 50
    ) async throws -> [Track] {
        guard (artist != nil && track != nil) || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist and track or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let track = track { parameters["track"] = track }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        parameters["limit"] = String(limit)
        
        let endpoint = buildEndpoint(category: "track", method: "getSimilar", parameters: parameters)
        let response: TrackSimilarResponse = try await networkClient.request(endpoint)
        return response.similartracks.track
    }
    
    public func getTopTags(
        artist: String,
        track: String,
        mbid: String? = nil,
        autocorrect: Bool = false
    ) async throws -> [Tag] {
        var parameters: [String: String] = [
            "artist": artist,
            "track": track
        ]
        
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        
        let endpoint = buildEndpoint(category: "track", method: "getTopTags", parameters: parameters)
        let response: TrackTopTagsResponse = try await networkClient.request(endpoint)
        return response.toptags.tag
    }
    
    public func search(
        track: String,
        artist: String? = nil,
        limit: Int = 30,
        page: Int = 1
    ) async throws -> (tracks: [Track], pagination: PaginationAttributes) {
        var parameters: [String: String] = [
            "track": track,
            "limit": String(limit),
            "page": String(page)
        ]
        
        if let artist = artist { parameters["artist"] = artist }
        
        let endpoint = buildEndpoint(category: "track", method: "search", parameters: parameters)
        let response: TrackSearchResponse = try await networkClient.request(endpoint)
        return (response.results.trackmatches.track, response.results.paginationAttributes)
    }
}
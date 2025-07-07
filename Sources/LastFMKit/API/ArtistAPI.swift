import Foundation

public final class ArtistAPI: BaseAPI {
    
    public func getCorrection(artist: String) async throws -> Artist? {
        let parameters = ["artist": artist]
        let endpoint = buildEndpoint(category: "artist", method: "getCorrection", parameters: parameters)
        let response: ArtistCorrectionResponse = try await networkClient.request(endpoint)
        return response.corrections.correction?.artist
    }
    
    public func getInfo(
        artist: String? = nil,
        mbid: String? = nil,
        lang: String? = nil,
        autocorrect: Bool = false,
        username: String? = nil
    ) async throws -> Artist {
        guard artist != nil || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if let lang = lang { parameters["lang"] = lang }
        if autocorrect { parameters["autocorrect"] = "1" }
        if let username = username { parameters["username"] = username }
        
        let endpoint = buildEndpoint(category: "artist", method: "getInfo", parameters: parameters)
        let response: ArtistInfoResponse = try await networkClient.request(endpoint)
        return response.artist
    }
    
    public func getSimilar(
        artist: String? = nil,
        mbid: String? = nil,
        limit: Int = 50,
        autocorrect: Bool = false
    ) async throws -> [Artist] {
        guard artist != nil || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let mbid = mbid { parameters["mbid"] = mbid }
        parameters["limit"] = String(limit)
        if autocorrect { parameters["autocorrect"] = "1" }
        
        let endpoint = buildEndpoint(category: "artist", method: "getSimilar", parameters: parameters)
        let response: ArtistSimilarResponse = try await networkClient.request(endpoint)
        return response.similarartists.artist
    }
    
    public func getTopAlbums(
        artist: String? = nil,
        mbid: String? = nil,
        autocorrect: Bool = false,
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (albums: [Album], pagination: PaginationAttributes) {
        guard artist != nil || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        parameters["page"] = String(page)
        parameters["limit"] = String(limit)
        
        let endpoint = buildEndpoint(category: "artist", method: "getTopAlbums", parameters: parameters)
        let response: ArtistTopAlbumsResponse = try await networkClient.request(endpoint)
        return (response.topalbums.album, response.topalbums.attr)
    }
    
    public func getTopTags(
        artist: String? = nil,
        mbid: String? = nil,
        autocorrect: Bool = false
    ) async throws -> [Tag] {
        guard artist != nil || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        
        let endpoint = buildEndpoint(category: "artist", method: "getTopTags", parameters: parameters)
        let response: ArtistTopTagsResponse = try await networkClient.request(endpoint)
        return response.toptags.tag
    }
    
    public func getTopTracks(
        artist: String? = nil,
        mbid: String? = nil,
        autocorrect: Bool = false,
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (tracks: [Track], pagination: PaginationAttributes) {
        guard artist != nil || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        parameters["page"] = String(page)
        parameters["limit"] = String(limit)
        
        let endpoint = buildEndpoint(category: "artist", method: "getTopTracks", parameters: parameters)
        let response: ArtistTopTracksResponse = try await networkClient.request(endpoint)
        return (response.toptracks.track, response.toptracks.attr)
    }
    
    public func search(
        artist: String,
        limit: Int = 30,
        page: Int = 1
    ) async throws -> (artists: [Artist], pagination: PaginationAttributes) {
        let parameters: [String: String] = [
            "artist": artist,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "artist", method: "search", parameters: parameters)
        let response: ArtistSearchResponse = try await networkClient.request(endpoint)
        return (response.results.artistmatches.artist, response.results.paginationAttributes)
    }
}
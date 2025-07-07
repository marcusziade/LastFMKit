import Foundation

public final class AlbumAPI: BaseAPI {
    
    public func getInfo(
        artist: String? = nil,
        album: String? = nil,
        mbid: String? = nil,
        autocorrect: Bool = false,
        username: String? = nil,
        lang: String? = nil
    ) async throws -> Album {
        guard (artist != nil && album != nil) || mbid != nil else {
            throw LastFMError.invalidParameters("Either artist and album or mbid must be provided")
        }
        
        var parameters: [String: String] = [:]
        if let artist = artist { parameters["artist"] = artist }
        if let album = album { parameters["album"] = album }
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        if let username = username { parameters["username"] = username }
        if let lang = lang { parameters["lang"] = lang }
        
        let endpoint = buildEndpoint(category: "album", method: "getInfo", parameters: parameters)
        let response: AlbumInfoResponse = try await networkClient.request(endpoint)
        return response.album
    }
    
    public func getTopTags(
        artist: String,
        album: String,
        mbid: String? = nil,
        autocorrect: Bool = false
    ) async throws -> [Tag] {
        var parameters: [String: String] = [
            "artist": artist,
            "album": album
        ]
        
        if let mbid = mbid { parameters["mbid"] = mbid }
        if autocorrect { parameters["autocorrect"] = "1" }
        
        let endpoint = buildEndpoint(category: "album", method: "getTopTags", parameters: parameters)
        let response: AlbumTopTagsResponse = try await networkClient.request(endpoint)
        return response.toptags.tag
    }
    
    public func search(
        album: String,
        limit: Int = 30,
        page: Int = 1
    ) async throws -> (albums: [Album], pagination: PaginationAttributes) {
        let parameters: [String: String] = [
            "album": album,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "album", method: "search", parameters: parameters)
        let response: AlbumSearchResponse = try await networkClient.request(endpoint)
        return (response.results.albummatches.album, response.results.paginationAttributes)
    }
}
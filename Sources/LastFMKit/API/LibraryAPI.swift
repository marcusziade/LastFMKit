import Foundation

public final class LibraryAPI: BaseAPI {
    
    public func getArtists(
        user: String,
        limit: Int = 50,
        page: Int = 1
    ) async throws -> (artists: [Artist], attributes: LibraryAttributes) {
        let parameters = [
            "user": user,
            "limit": String(limit),
            "page": String(page)
        ]
        
        let endpoint = buildEndpoint(category: "library", method: "getArtists", parameters: parameters)
        let response: LibraryArtistsResponse = try await networkClient.request(endpoint)
        return (response.artists.artist, response.artists.attr)
    }
}
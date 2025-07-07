import Foundation

/// Provides access to artist-related endpoints of the Last.fm API.
///
/// The `ArtistAPI` class offers comprehensive methods for retrieving artist information,
/// including biographical data, similar artists, top tracks/albums, and more.
///
/// ## Overview
///
/// All methods support both artist name and MusicBrainz ID (MBID) for identification,
/// with automatic correction capabilities for misspelled artist names.
///
/// ## Topics
///
/// ### Artist Information
/// - ``getInfo(artist:mbid:lang:autocorrect:username:)``
/// - ``getCorrection(artist:)``
///
/// ### Discovery
/// - ``search(artist:limit:page:)``
/// - ``getSimilar(artist:mbid:limit:autocorrect:)``
///
/// ### Top Content
/// - ``getTopTracks(artist:mbid:autocorrect:page:limit:)``
/// - ``getTopAlbums(artist:mbid:autocorrect:page:limit:)``
/// - ``getTopTags(artist:mbid:autocorrect:)``
public final class ArtistAPI: BaseAPI {
    
    /// Returns a spelling correction for an artist name.
    ///
    /// Use this method to get the canonical spelling of an artist name,
    /// which is useful for ensuring consistency in your application.
    ///
    /// - Parameter artist: The artist name to check for corrections
    /// - Returns: The corrected artist information if a correction exists, nil otherwise
    /// - Throws: ``LastFMError`` if the request fails
    ///
    /// ## Example
    /// ```swift
    /// // Get correction for misspelled artist name
    /// if let corrected = try await client.artist.getCorrection(artist: "Radiohed") {
    ///     print("Did you mean: \(corrected.name)?")
    /// }
    /// ```
    public func getCorrection(artist: String) async throws -> Artist? {
        let parameters = ["artist": artist]
        let endpoint = buildEndpoint(category: "artist", method: "getCorrection", parameters: parameters)
        let response: ArtistCorrectionResponse = try await networkClient.request(endpoint)
        return response.corrections.correction?.artist
    }
    
    /// Retrieves detailed information about an artist.
    ///
    /// This method returns comprehensive artist data including biography, statistics,
    /// similar artists preview, and tags. You can identify the artist either by name or MBID.
    ///
    /// - Parameters:
    ///   - artist: The artist name (optional if mbid is provided)
    ///   - mbid: The MusicBrainz ID of the artist (optional if artist is provided)
    ///   - lang: The language for the biography (ISO 639 alpha-2 code)
    ///   - autocorrect: Whether to autocorrect misspelled artist names
    ///   - username: Username to check if the user has loved this artist
    /// - Returns: Detailed artist information
    /// - Throws: ``LastFMError/invalidParameters(_:)`` if neither artist nor mbid is provided
    ///
    /// ## Example
    /// ```swift
    /// // Get artist info by name
    /// let artist = try await client.artist.getInfo(
    ///     artist: "Radiohead",
    ///     lang: "en",
    ///     autocorrect: true
    /// )
    /// print("Listeners: \(artist.stats?.listeners ?? 0)")
    /// print("Biography: \(artist.bio?.summary ?? "")")
    ///
    /// // Get artist info with user context
    /// let artistWithUserData = try await client.artist.getInfo(
    ///     artist: "Radiohead",
    ///     username: "john_doe"
    /// )
    /// ```
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
    
    /// Finds artists similar to a given artist.
    ///
    /// Returns a list of artists that are similar in style or genre to the specified artist,
    /// ordered by similarity score.
    ///
    /// - Parameters:
    ///   - artist: The artist name (optional if mbid is provided)
    ///   - mbid: The MusicBrainz ID of the artist (optional if artist is provided)
    ///   - limit: Maximum number of similar artists to return (default: 50, max: 100)
    ///   - autocorrect: Whether to autocorrect misspelled artist names
    /// - Returns: Array of similar artists ordered by similarity
    /// - Throws: ``LastFMError/invalidParameters(_:)`` if neither artist nor mbid is provided
    ///
    /// ## Example
    /// ```swift
    /// // Find artists similar to Radiohead
    /// let similar = try await client.artist.getSimilar(
    ///     artist: "Radiohead",
    ///     limit: 10
    /// )
    /// 
    /// for artist in similar {
    ///     print("\(artist.name) - Match: \(artist.match ?? 0)%")
    /// }
    /// ```
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
    
    /// Gets the top albums for an artist.
    ///
    /// Returns the most popular albums by the specified artist, ordered by popularity on Last.fm.
    /// Results are paginated to handle artists with large discographies.
    ///
    /// - Parameters:
    ///   - artist: The artist name (optional if mbid is provided)
    ///   - mbid: The MusicBrainz ID of the artist (optional if artist is provided)
    ///   - autocorrect: Whether to autocorrect misspelled artist names
    ///   - page: The page number to fetch (default: 1)
    ///   - limit: Number of albums per page (default: 50, max: 1000)
    /// - Returns: A tuple containing the albums and pagination information
    /// - Throws: ``LastFMError/invalidParameters(_:)`` if neither artist nor mbid is provided
    ///
    /// ## Example
    /// ```swift
    /// // Get top albums for an artist
    /// let (albums, pagination) = try await client.artist.getTopAlbums(
    ///     artist: "Pink Floyd",
    ///     limit: 20
    /// )
    /// 
    /// print("Total albums: \(pagination.total)")
    /// for album in albums {
    ///     print("\(album.name) - Plays: \(album.playcount ?? 0)")
    /// }
    /// ```
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
    
    /// Gets the top tags for an artist.
    ///
    /// Returns the most frequently applied tags for the specified artist,
    /// which can be useful for categorization and discovery.
    ///
    /// - Parameters:
    ///   - artist: The artist name (optional if mbid is provided)
    ///   - mbid: The MusicBrainz ID of the artist (optional if artist is provided)
    ///   - autocorrect: Whether to autocorrect misspelled artist names
    /// - Returns: Array of tags ordered by frequency
    /// - Throws: ``LastFMError/invalidParameters(_:)`` if neither artist nor mbid is provided
    ///
    /// ## Example
    /// ```swift
    /// // Get top tags for an artist
    /// let tags = try await client.artist.getTopTags(artist: "Daft Punk")
    /// 
    /// for tag in tags.prefix(5) {
    ///     print("\(tag.name) - Count: \(tag.count ?? 0)")
    /// }
    /// ```
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
    
    /// Gets the top tracks for an artist.
    ///
    /// Returns the most popular tracks by the specified artist, ordered by play count on Last.fm.
    /// Results are paginated for artists with extensive catalogs.
    ///
    /// - Parameters:
    ///   - artist: The artist name (optional if mbid is provided)
    ///   - mbid: The MusicBrainz ID of the artist (optional if artist is provided)
    ///   - autocorrect: Whether to autocorrect misspelled artist names
    ///   - page: The page number to fetch (default: 1)
    ///   - limit: Number of tracks per page (default: 50, max: 1000)
    /// - Returns: A tuple containing the tracks and pagination information
    /// - Throws: ``LastFMError/invalidParameters(_:)`` if neither artist nor mbid is provided
    ///
    /// ## Example
    /// ```swift
    /// // Get top tracks for an artist
    /// let (tracks, pagination) = try await client.artist.getTopTracks(
    ///     artist: "The Beatles",
    ///     limit: 10
    /// )
    /// 
    /// for (index, track) in tracks.enumerated() {
    ///     print("\(index + 1). \(track.name) - Plays: \(track.playcount ?? 0)")
    /// }
    /// 
    /// // Load more tracks
    /// if pagination.page < pagination.totalPages {
    ///     let (moreTracks, _) = try await client.artist.getTopTracks(
    ///         artist: "The Beatles",
    ///         page: pagination.page + 1
    ///     )
    /// }
    /// ```
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
    
    /// Searches for artists by name.
    ///
    /// Performs a text search for artists matching the given query string.
    /// Results are ordered by relevance and popularity.
    ///
    /// - Parameters:
    ///   - artist: The search query string
    ///   - limit: Number of results per page (default: 30, max: 1000)
    ///   - page: The page number to fetch (default: 1)
    /// - Returns: A tuple containing the matching artists and pagination information
    /// - Throws: ``LastFMError`` if the request fails
    ///
    /// ## Example
    /// ```swift
    /// // Search for artists
    /// let (results, pagination) = try await client.artist.search(
    ///     artist: "Radio",
    ///     limit: 5
    /// )
    /// 
    /// print("Found \(pagination.total) total results")
    /// for artist in results {
    ///     print("\(artist.name) - Listeners: \(artist.listeners ?? "0")")
    /// }
    /// ```
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
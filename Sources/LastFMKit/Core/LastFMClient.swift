import Foundation
import Logging

/// The main entry point for interacting with the Last.fm API.
///
/// `LastFMClient` provides a unified interface to all Last.fm API endpoints through specialized API objects.
/// It handles network configuration, retry policies, and logging automatically.
///
/// ## Overview
/// 
/// The client is designed with a modular architecture where each API category (artists, albums, tracks, etc.)
/// is accessible through dedicated properties. This provides better organization and discoverability of available methods.
///
/// ## Basic Usage
/// 
/// ```swift
/// // Create a client with default configuration
/// let client = LastFMClient()
/// 
/// // Search for an artist
/// let results = try await client.artist.search("Radiohead", limit: 10)
/// 
/// // Get user's recent tracks
/// let recentTracks = try await client.user.getRecentTracks("username")
/// ```
///
/// ## Configuration
/// 
/// You can customize the client behavior using a `ClientConfiguration`:
/// 
/// ```swift
/// let config = ClientConfiguration(
///     baseURL: "https://custom-proxy.example.com",
///     timeout: 60,
///     retryPolicy: .exponentialBackoff(maxRetries: 5)
/// )
/// let client = LastFMClient(configuration: config)
/// ```
///
/// ## API Categories
/// 
/// - ``album``: Album-related operations (search, info, tags)
/// - ``artist``: Artist-related operations (search, similar, top tracks)
/// - ``track``: Track-related operations (search, similar, info)
/// - ``chart``: Chart data (top artists, tracks)
/// - ``geo``: Geographic data (top artists/tracks by country)
/// - ``tag``: Tag-related operations (top tags, tagged items)
/// - ``user``: User data (profile, recent tracks, top items)
/// - ``library``: User library operations (scrobbles)
/// - ``auth``: Authentication operations
///
/// ## Error Handling
/// 
/// All API methods throw ``LastFMError`` which provides detailed error information:
/// 
/// ```swift
/// do {
///     let artist = try await client.artist.getInfo("Unknown Artist")
/// } catch let error as LastFMError {
///     switch error {
///     case .notFound:
///         print("Artist not found")
///     case .rateLimitExceeded:
///         print("Too many requests")
///     default:
///         print("Error: \(error.localizedDescription)")
///     }
/// }
/// ```
///
/// ## Thread Safety
/// 
/// `LastFMClient` is thread-safe and can be shared across multiple concurrent operations.
public final class LastFMClient {
    /// The base URL for all API requests.
    /// Default: `https://lastfm-proxy-worker.guitaripod.workers.dev`
    public let baseURL: URL
    
    /// The underlying network client responsible for making HTTP requests.
    public let networkClient: NetworkClientProtocol
    
    /// Logger instance for debugging and monitoring API calls.
    public let logger: Logger
    
    /// Access album-related API endpoints.
    /// 
    /// Provides methods for searching albums, getting album information,
    /// and retrieving album-specific data like tracks and tags.
    public let album: AlbumAPI
    
    /// Access artist-related API endpoints.
    /// 
    /// Provides methods for searching artists, finding similar artists,
    /// getting top tracks/albums, and retrieving artist information.
    public let artist: ArtistAPI
    
    /// Access track-related API endpoints.
    /// 
    /// Provides methods for searching tracks, finding similar tracks,
    /// and getting detailed track information.
    public let track: TrackAPI
    
    /// Access chart data endpoints.
    /// 
    /// Provides methods for retrieving top artists and tracks globally.
    public let chart: ChartAPI
    
    /// Access geographic data endpoints.
    /// 
    /// Provides methods for getting top artists and tracks by country.
    public let geo: GeoAPI
    
    /// Access tag-related API endpoints.
    /// 
    /// Provides methods for exploring tags, getting tagged items,
    /// and retrieving tag information.
    public let tag: TagAPI
    
    /// Access user-related API endpoints.
    /// 
    /// Provides methods for retrieving user profiles, recent tracks,
    /// top artists/albums/tracks, and friends.
    public let user: UserAPI
    
    /// Access user library endpoints.
    /// 
    /// Provides methods for managing user's music library and scrobbles.
    public let library: LibraryAPI
    
    /// Access authentication endpoints.
    /// 
    /// Provides methods for Last.fm authentication and session management.
    public let auth: AuthAPI
    
    /// Creates a new Last.fm API client with the specified configuration.
    /// 
    /// - Parameters:
    ///   - baseURL: The base URL for API requests. Default: `https://lastfm-proxy-worker.guitaripod.workers.dev`
    ///   - timeout: Request timeout in seconds. Default: 30 seconds
    ///   - retryPolicy: Policy for retrying failed requests. Default: exponential backoff with 3 retries
    /// 
    /// - Note: The client will terminate the process if an invalid base URL is provided.
    public init(
        baseURL: String = "https://lastfm-proxy-worker.guitaripod.workers.dev",
        timeout: TimeInterval = 30,
        retryPolicy: RetryPolicy = .exponentialBackoff(maxRetries: 3)
    ) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        
        self.baseURL = url
        self.logger = Logger(label: "LastFMKit.Client")
        
        let configuration = NetworkConfiguration(timeout: timeout, retryPolicy: retryPolicy)
        let networkClient = NetworkClient(configuration: configuration)
        self.networkClient = networkClient
        
        self.album = AlbumAPI(baseURL: url, networkClient: networkClient)
        self.artist = ArtistAPI(baseURL: url, networkClient: networkClient)
        self.track = TrackAPI(baseURL: url, networkClient: networkClient)
        self.chart = ChartAPI(baseURL: url, networkClient: networkClient)
        self.geo = GeoAPI(baseURL: url, networkClient: networkClient)
        self.tag = TagAPI(baseURL: url, networkClient: networkClient)
        self.user = UserAPI(baseURL: url, networkClient: networkClient)
        self.library = LibraryAPI(baseURL: url, networkClient: networkClient)
        self.auth = AuthAPI(baseURL: url, networkClient: networkClient)
        
        logger.info("LastFMClient initialized with base URL: \(baseURL)")
    }
    
    /// Creates a new Last.fm API client with a configuration object.
    /// 
    /// - Parameter configuration: The client configuration containing baseURL, timeout, and retry policy
    /// 
    /// ## Example
    /// ```swift
    /// let config = ClientConfiguration(
    ///     timeout: 60,
    ///     retryPolicy: .linear(delay: 2, maxRetries: 5)
    /// )
    /// let client = LastFMClient(configuration: config)
    /// ```
    public convenience init(configuration: ClientConfiguration) {
        self.init(
            baseURL: configuration.baseURL,
            timeout: configuration.timeout,
            retryPolicy: configuration.retryPolicy
        )
    }
}

/// Configuration options for customizing LastFMClient behavior.
///
/// Use this struct to configure network timeouts, retry policies, and the API base URL.
///
/// ## Example
/// ```swift
/// let configuration = ClientConfiguration(
///     timeout: 60, // 60 second timeout
///     retryPolicy: .exponentialBackoff(maxRetries: 5)
/// )
/// let client = LastFMClient(configuration: configuration)
/// ```
public struct ClientConfiguration {
    /// The base URL for API requests.
    /// Default: `https://lastfm-proxy-worker.guitaripod.workers.dev`
    public let baseURL: String
    
    /// Request timeout duration in seconds.
    /// Default: 30 seconds
    public let timeout: TimeInterval
    
    /// The retry policy for handling failed requests.
    /// Default: Exponential backoff with 3 maximum retries
    public let retryPolicy: RetryPolicy
    
    /// Creates a new client configuration.
    /// 
    /// - Parameters:
    ///   - baseURL: The base URL for API requests
    ///   - timeout: Request timeout in seconds
    ///   - retryPolicy: Policy for retrying failed requests
    public init(
        baseURL: String = "https://lastfm-proxy-worker.guitaripod.workers.dev",
        timeout: TimeInterval = 30,
        retryPolicy: RetryPolicy = .exponentialBackoff(maxRetries: 3)
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.retryPolicy = retryPolicy
    }
    
    /// The default configuration with standard timeout and retry settings.
    /// 
    /// Uses:
    /// - Base URL: `https://lastfm-proxy-worker.guitaripod.workers.dev`
    /// - Timeout: 30 seconds
    /// - Retry Policy: Exponential backoff with 3 retries
    public static let `default` = ClientConfiguration()
}
import Foundation
import Logging

public final class LastFMClient {
    public let baseURL: URL
    public let networkClient: NetworkClientProtocol
    public let logger: Logger
    
    public let album: AlbumAPI
    public let artist: ArtistAPI
    public let track: TrackAPI
    public let chart: ChartAPI
    public let geo: GeoAPI
    public let tag: TagAPI
    public let user: UserAPI
    public let library: LibraryAPI
    public let auth: AuthAPI
    
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
    
    public convenience init(configuration: ClientConfiguration) {
        self.init(
            baseURL: configuration.baseURL,
            timeout: configuration.timeout,
            retryPolicy: configuration.retryPolicy
        )
    }
}

public struct ClientConfiguration {
    public let baseURL: String
    public let timeout: TimeInterval
    public let retryPolicy: RetryPolicy
    
    public init(
        baseURL: String = "https://lastfm-proxy-worker.guitaripod.workers.dev",
        timeout: TimeInterval = 30,
        retryPolicy: RetryPolicy = .exponentialBackoff(maxRetries: 3)
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.retryPolicy = retryPolicy
    }
    
    public static let `default` = ClientConfiguration()
}
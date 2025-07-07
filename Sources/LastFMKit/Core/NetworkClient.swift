import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Data
}

public actor NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let logger: Logger
    private let configuration: NetworkConfiguration
    
    public init(configuration: NetworkConfiguration = .default) {
        self.configuration = configuration
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeout
        sessionConfig.timeoutIntervalForResource = configuration.timeout * 2
        #if !os(Linux)
        sessionConfig.waitsForConnectivity = true
        #endif
        
        self.session = URLSession(configuration: sessionConfig)
        self.logger = Logger(label: "LastFMKit.NetworkClient")
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        
        do {
            if let apiError = try? JSONDecoder().decode(LastFMAPIError.self, from: data) {
                throw mapAPIError(apiError)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            logger.error("Decoding error: \(error)")
            throw LastFMError.decodingError(error)
        }
    }
    
    public func request(_ endpoint: Endpoint) async throws -> Data {
        guard let url = endpoint.url else {
            throw LastFMError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        let maxRetries = configuration.retryPolicy.maxRetries
        var lastError: Error?
        
        for attempt in 0...maxRetries {
            if attempt > 0 {
                let delay = configuration.retryPolicy.delay(for: attempt)
                logger.debug("Retrying request (attempt \(attempt + 1)) after \(delay)s delay")
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            do {
                logger.debug("Making request to: \(url)")
                let (data, response) = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
                    let task = session.dataTask(with: request) { data, response, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let data = data, let response = response {
                            continuation.resume(returning: (data, response))
                        } else {
                            continuation.resume(throwing: URLError(.unknown))
                        }
                    }
                    task.resume()
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw LastFMError.networkError(URLError(.badServerResponse))
                }
                
                logger.debug("Response status code: \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 429:
                    throw LastFMError.rateLimitExceeded
                case 503:
                    if attempt < maxRetries {
                        lastError = LastFMError.serviceOffline
                        continue
                    }
                    throw LastFMError.serviceOffline
                default:
                    if let apiError = try? JSONDecoder().decode(LastFMAPIError.self, from: data) {
                        throw mapAPIError(apiError)
                    }
                    throw LastFMError.serverError(statusCode: httpResponse.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            } catch {
                lastError = error
                
                if !isRetriableError(error) || attempt == maxRetries {
                    throw error is LastFMError ? error : LastFMError.networkError(error)
                }
            }
        }
        
        throw lastError ?? LastFMError.networkError(URLError(.unknown))
    }
    
    private func isRetriableError(_ error: Error) -> Bool {
        if let lastFMError = error as? LastFMError {
            switch lastFMError {
            case .serviceOffline, .temporaryError, .networkError:
                return true
            default:
                return false
            }
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut, .networkConnectionLost, .notConnectedToInternet:
                return true
            default:
                return false
            }
        }
        
        return false
    }
    
    private func mapAPIError(_ apiError: LastFMAPIError) -> LastFMError {
        switch apiError.error {
        case 6:
            return .invalidParameters(apiError.message)
        case 10:
            return .invalidAPIKey
        case 11:
            return .serviceOffline
        case 13:
            return .invalidSignature
        case 16:
            return .temporaryError
        case 29:
            return .rateLimitExceeded
        default:
            return .apiError(code: apiError.error, message: apiError.message)
        }
    }
}

public struct NetworkConfiguration {
    public let timeout: TimeInterval
    public let retryPolicy: RetryPolicy
    
    public init(timeout: TimeInterval = 30, retryPolicy: RetryPolicy = .exponentialBackoff(maxRetries: 3)) {
        self.timeout = timeout
        self.retryPolicy = retryPolicy
    }
    
    public static let `default` = NetworkConfiguration()
}

public enum RetryPolicy {
    case none
    case fixed(maxRetries: Int, delay: TimeInterval)
    case exponentialBackoff(maxRetries: Int, initialDelay: TimeInterval = 1.0)
    
    var maxRetries: Int {
        switch self {
        case .none:
            return 0
        case .fixed(let maxRetries, _), .exponentialBackoff(let maxRetries, _):
            return maxRetries
        }
    }
    
    func delay(for attempt: Int) -> TimeInterval {
        switch self {
        case .none:
            return 0
        case .fixed(_, let delay):
            return delay
        case .exponentialBackoff(_, let initialDelay):
            return initialDelay * pow(2, Double(attempt - 1))
        }
    }
}
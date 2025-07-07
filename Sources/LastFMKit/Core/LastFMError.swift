import Foundation

/// Errors that can occur when interacting with the Last.fm API.
///
/// `LastFMError` provides a comprehensive set of error cases that cover network failures,
/// API-specific errors, and client-side validation errors.
///
/// ## Error Categories
///
/// ### Client Errors
/// - ``invalidParameters(_:)`` - Invalid parameters provided to a method
/// - ``invalidURL`` - Malformed URL construction
/// - ``decodingError(_:)`` - Failed to decode API response
///
/// ### Network Errors
/// - ``networkError(_:)`` - Underlying network failure
/// - ``noData`` - No data received from server
/// - ``serverError(statusCode:message:)`` - HTTP error response
///
/// ### API Errors
/// - ``apiError(code:message:)`` - Last.fm API specific error
/// - ``rateLimitExceeded`` - Too many requests
/// - ``authenticationRequired`` - Authentication needed for endpoint
/// - ``invalidAPIKey`` - Invalid or missing API key
/// - ``serviceOffline`` - Last.fm service temporarily unavailable
/// - ``invalidSignature`` - Invalid method signature
/// - ``temporaryError`` - Temporary failure, can retry
/// - ``invalidMethod`` - Unknown API method
///
/// ## Error Handling Example
///
/// ```swift
/// do {
///     let artist = try await client.artist.getInfo(artist: "Unknown")
/// } catch let error as LastFMError {
///     switch error {
///     case .invalidParameters(let message):
///         print("Invalid input: \(message)")
///     case .networkError(let underlying):
///         print("Network failed: \(underlying)")
///     case .rateLimitExceeded:
///         print("Please wait before trying again")
///     case .apiError(let code, let message):
///         print("API error \(code): \(message)")
///     default:
///         print("Error: \(error.localizedDescription)")
///     }
/// }
/// ```
public enum LastFMError: LocalizedError {
    /// Invalid parameters were provided to an API method.
    ///
    /// This error includes a descriptive message explaining what parameter was invalid.
    case invalidParameters(String)
    
    /// A network error occurred during the request.
    ///
    /// The underlying error provides additional details about the network failure.
    case networkError(Error)
    
    /// Failed to decode the API response.
    ///
    /// This typically indicates the API returned data in an unexpected format.
    case decodingError(Error)
    
    /// The server returned an HTTP error.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code
    ///   - message: Error message from the server
    case serverError(statusCode: Int, message: String)
    
    /// The API rate limit has been exceeded.
    ///
    /// Wait a moment before retrying the request. The SDK will automatically
    /// retry with exponential backoff if configured.
    case rateLimitExceeded
    
    /// The URL construction failed.
    ///
    /// This indicates a programming error in URL building.
    case invalidURL
    
    /// No data was received from the server.
    ///
    /// The server returned an empty response when data was expected.
    case noData
    
    /// The Last.fm API returned an error.
    ///
    /// - Parameters:
    ///   - code: Last.fm error code
    ///   - message: Error description from the API
    ///
    /// Common error codes:
    /// - 2: Invalid service
    /// - 3: Invalid method
    /// - 4: Authentication failed
    /// - 5: Invalid format
    /// - 6: Invalid parameters
    /// - 7: Invalid resource
    /// - 8: Operation failed
    /// - 9: Invalid session key
    /// - 10: Invalid API key
    /// - 11: Service offline
    /// - 13: Invalid method signature
    /// - 16: Temporary error
    /// - 26: Suspended API key
    /// - 29: Rate limit exceeded
    case apiError(code: Int, message: String)
    
    /// Authentication is required for this endpoint.
    ///
    /// The requested operation requires user authentication.
    /// See ``AuthAPI`` for authentication methods.
    case authenticationRequired
    
    /// The API key is invalid or missing.
    ///
    /// Check your API key configuration.
    case invalidAPIKey
    
    /// The Last.fm service is temporarily offline.
    ///
    /// This is typically a temporary condition. Retry after a delay.
    case serviceOffline
    
    /// The method signature is invalid.
    ///
    /// This usually indicates incorrect authentication parameters.
    case invalidSignature
    
    /// A temporary error occurred.
    ///
    /// The request can be retried after a short delay.
    case temporaryError
    
    /// The API method name is invalid.
    ///
    /// Check that you're using a valid Last.fm API method.
    case invalidMethod
    
    /// A human-readable description of the error.
    public var errorDescription: String? {
        switch self {
        case .invalidParameters(let message):
            return "Invalid parameters: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return "Server error (\(statusCode)): \(message)"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .apiError(let code, let message):
            return "API error \(code): \(message)"
        case .authenticationRequired:
            return "Authentication required for this operation"
        case .invalidAPIKey:
            return "Invalid API key"
        case .serviceOffline:
            return "Service is temporarily offline"
        case .invalidSignature:
            return "Invalid method signature"
        case .temporaryError:
            return "Temporary error, please try again"
        case .invalidMethod:
            return "Invalid API method"
        }
    }
}

/// Represents an error response from the Last.fm API.
///
/// This structure is used internally to decode error responses
/// from the API and convert them to appropriate ``LastFMError`` cases.
public struct LastFMAPIError: Codable {
    /// The numeric error code from Last.fm.
    public let error: Int
    
    /// The error message describing what went wrong.
    public let message: String
}
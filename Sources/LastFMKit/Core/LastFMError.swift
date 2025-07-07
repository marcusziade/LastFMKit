import Foundation

public enum LastFMError: LocalizedError {
    case invalidParameters(String)
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)
    case rateLimitExceeded
    case invalidURL
    case noData
    case apiError(code: Int, message: String)
    case authenticationRequired
    case invalidAPIKey
    case serviceOffline
    case invalidSignature
    case temporaryError
    case invalidMethod
    
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

public struct LastFMAPIError: Codable {
    public let error: Int
    public let message: String
}
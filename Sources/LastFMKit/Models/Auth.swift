import Foundation

public struct AuthSessionResponse: Codable {
    public let session: Session
}

public struct Session: Codable {
    public let name: String
    public let key: String
    public let subscriber: Int
}

public struct AuthMobileSessionResponse: Codable {
    public let session: Session
}
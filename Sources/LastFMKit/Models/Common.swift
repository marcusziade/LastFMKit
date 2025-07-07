import Foundation

public struct LastFMImage: Codable {
    public let text: String
    public let size: ImageSize
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

public enum ImageSize: String, Codable {
    case small
    case medium
    case large
    case extralarge
    case mega
    case unknown = ""
}

public struct PaginationAttributes: Codable {
    public let page: String
    public let perPage: String
    public let total: String
    public let totalPages: String
    
    public var pageInt: Int { Int(page) ?? 1 }
    public var perPageInt: Int { Int(perPage) ?? 50 }
    public var totalInt: Int { Int(total) ?? 0 }
    public var totalPagesInt: Int { Int(totalPages) ?? 0 }
}

public struct Wiki: Codable {
    public let published: String?
    public let summary: String?
    public let content: String?
}

public struct DateInfo: Codable {
    public let uts: String?
    public let unixtime: String?
    public let text: StringOrInt
    
    private enum CodingKeys: String, CodingKey {
        case uts
        case unixtime
        case text = "#text"
    }
    
    public var date: Date? {
        if let uts = uts, let timestamp = TimeInterval(uts) {
            return Date(timeIntervalSince1970: timestamp)
        } else if let unixtime = unixtime, let timestamp = TimeInterval(unixtime) {
            return Date(timeIntervalSince1970: timestamp)
        } else if let timestamp = TimeInterval(text.value) {
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }
}

public struct Streamable: Codable {
    public let text: String
    public let fulltrack: String
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case fulltrack
    }
    
    public var isStreamable: Bool {
        return text == "1"
    }
}

public enum StreamableValue: Codable {
    case string(String)
    case object(Streamable)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let streamable = try? container.decode(Streamable.self) {
            self = .object(streamable)
        } else {
            throw DecodingError.typeMismatch(StreamableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Streamable object"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .object(let streamable):
            try container.encode(streamable)
        }
    }
    
    public var isStreamable: Bool {
        switch self {
        case .string(let value):
            return value == "1"
        case .object(let streamable):
            return streamable.isStreamable
        }
    }
}

public enum Period: String, CaseIterable {
    case overall
    case sevenDay = "7day"
    case oneMonth = "1month"
    case threeMonth = "3month"
    case sixMonth = "6month"
    case twelveMonth = "12month"
}

public struct StringOrInt: Codable {
    public let value: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = String(intValue)
        } else {
            self.value = try container.decode(String.self)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
    
    public var intValue: Int? {
        return Int(value)
    }
}
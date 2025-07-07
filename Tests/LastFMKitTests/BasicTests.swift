import XCTest
import Foundation
@testable import LastFMKit

final class BasicTests: XCTestCase {
    
    func testClientInitialization() {
        // Just verify client can be created without throwing
        let client = LastFMClient()
        let _ = client // Use the client to avoid unused variable warning
    }
    
    func testPeriodEnumValues() {
        XCTAssertEqual(Period.overall.rawValue, "overall")
        XCTAssertEqual(Period.sevenDay.rawValue, "7day")
        XCTAssertEqual(Period.oneMonth.rawValue, "1month")
        XCTAssertEqual(Period.threeMonth.rawValue, "3month")
        XCTAssertEqual(Period.sixMonth.rawValue, "6month")
        XCTAssertEqual(Period.twelveMonth.rawValue, "12month")
    }
    
    func testHTTPMethodValues() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
    }
    
    func testStringOrIntDecoding() throws {
        struct TestModel: Codable {
            let value: StringOrInt
        }
        
        // Test with string
        let jsonString = """
        { "value": "123" }
        """
        let data1 = jsonString.data(using: .utf8)!
        let model1 = try JSONDecoder().decode(TestModel.self, from: data1)
        XCTAssertEqual(model1.value.value, "123")
        
        // Test with int
        let jsonInt = """
        { "value": 123 }
        """
        let data2 = jsonInt.data(using: .utf8)!
        let model2 = try JSONDecoder().decode(TestModel.self, from: data2)
        XCTAssertEqual(model2.value.value, "123")
    }
    
    func testArtistDecoding() throws {
        let json = """
        {
            "name": "Radiohead",
            "url": "https://www.last.fm/music/Radiohead"
        }
        """
        
        let data = json.data(using: .utf8)!
        let artist = try JSONDecoder().decode(Artist.self, from: data)
        
        XCTAssertEqual(artist.name, "Radiohead")
        XCTAssertEqual(artist.url, "https://www.last.fm/music/Radiohead")
    }
    
    func testTrackDecoding() throws {
        let json = """
        {
            "name": "Creep",
            "url": "https://track.url",
            "artist": {
                "name": "Radiohead",
                "url": "https://artist.url"
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let track = try JSONDecoder().decode(Track.self, from: data)
        
        XCTAssertEqual(track.name, "Creep")
        XCTAssertEqual(track.url, "https://track.url")
        XCTAssertEqual(track.artist.name, "Radiohead")
    }
    
    func testAlbumDecoding() throws {
        let json = """
        {
            "name": "OK Computer",
            "artist": {
                "name": "Radiohead",
                "url": "https://www.last.fm/music/Radiohead"
            },
            "url": "https://www.last.fm/music/Radiohead/OK+Computer"
        }
        """
        
        let data = json.data(using: .utf8)!
        let album = try JSONDecoder().decode(Album.self, from: data)
        
        XCTAssertEqual(album.name, "OK Computer")
        XCTAssertEqual(album.artist.name, "Radiohead")
        XCTAssertEqual(album.url, "https://www.last.fm/music/Radiohead/OK+Computer")
    }
    
    func testURLEncodingSpecialCharacters() {
        // Test basic URL encoding
        let input1 = "Hello World"
        let encoded1 = input1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(encoded1, "Hello%20World")
        
        // Test that special characters are encoded
        let input2 = "test@example.com"
        let encoded2 = input2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertTrue(encoded2.contains("@")) // @ is allowed in urlQueryAllowed
        
        // Test empty string
        let input3 = ""
        let encoded3 = input3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        XCTAssertEqual(encoded3, "")
    }
    
    func testLastFMErrorBasics() {
        let invalidParams = LastFMError.invalidParameters("Missing required parameter")
        XCTAssertEqual(invalidParams.errorDescription, "Invalid parameters: Missing required parameter")
        
        let serviceOffline = LastFMError.serviceOffline
        XCTAssertEqual(serviceOffline.errorDescription, "Service is temporarily offline")
        
        let rateLimitExceeded = LastFMError.rateLimitExceeded
        XCTAssertEqual(rateLimitExceeded.errorDescription, "Rate limit exceeded")
        
        let apiError = LastFMError.apiError(code: 10, message: "Invalid API key")
        XCTAssertEqual(apiError.errorDescription, "API error 10: Invalid API key")
    }
}
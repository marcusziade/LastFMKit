import Testing
import Foundation
@testable import LastFMKit

struct BasicTests {
    
    @Test("LastFMClient initialization")
    func testClientInitialization() {
        // Just verify client can be created without throwing
        let client = LastFMClient()
        let _ = client // Use the client to avoid unused variable warning
    }
    
    @Test("Period enum values")
    func testPeriodEnumValues() {
        #expect(Period.overall.rawValue == "overall")
        #expect(Period.sevenDay.rawValue == "7day")
        #expect(Period.oneMonth.rawValue == "1month")
        #expect(Period.threeMonth.rawValue == "3month")
        #expect(Period.sixMonth.rawValue == "6month")
        #expect(Period.twelveMonth.rawValue == "12month")
    }
    
    @Test("HTTPMethod enum values")
    func testHTTPMethodValues() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
    }
    
    @Test("StringOrInt decoding")
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
        #expect(model1.value.value == "123")
        
        // Test with int
        let jsonInt = """
        { "value": 123 }
        """
        let data2 = jsonInt.data(using: .utf8)!
        let model2 = try JSONDecoder().decode(TestModel.self, from: data2)
        #expect(model2.value.value == "123")
    }
    
    @Test("Artist model basic decoding")
    func testArtistDecoding() throws {
        let json = """
        {
            "name": "Radiohead",
            "url": "https://www.last.fm/music/Radiohead"
        }
        """
        
        let data = json.data(using: .utf8)!
        let artist = try JSONDecoder().decode(Artist.self, from: data)
        
        #expect(artist.name == "Radiohead")
        #expect(artist.url == "https://www.last.fm/music/Radiohead")
    }
    
    @Test("Track model basic decoding")
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
        
        #expect(track.name == "Creep")
        #expect(track.url == "https://track.url")
        #expect(track.artist.name == "Radiohead")
    }
    
    @Test("Album model basic decoding")
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
        
        #expect(album.name == "OK Computer")
        #expect(album.artist.name == "Radiohead")
        #expect(album.url == "https://www.last.fm/music/Radiohead/OK+Computer")
    }
    
    @Test("URL encoding special characters")
    func testURLEncodingSpecialCharacters() {
        // Test basic URL encoding
        let input1 = "Hello World"
        let encoded1 = input1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        #expect(encoded1 == "Hello%20World")
        
        // Test that special characters are encoded
        let input2 = "test@example.com"
        let encoded2 = input2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        #expect(encoded2.contains("@")) // @ is allowed in urlQueryAllowed
        
        // Test empty string
        let input3 = ""
        let encoded3 = input3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        #expect(encoded3 == "")
    }
    
    @Test("LastFMError basic cases")
    func testLastFMErrorBasics() {
        let invalidParams = LastFMError.invalidParameters("Missing required parameter")
        #expect(invalidParams.errorDescription == "Invalid parameters: Missing required parameter")
        
        let serviceOffline = LastFMError.serviceOffline
        #expect(serviceOffline.errorDescription == "Service is temporarily offline")
        
        let rateLimitExceeded = LastFMError.rateLimitExceeded
        #expect(rateLimitExceeded.errorDescription == "Rate limit exceeded")
        
        let apiError = LastFMError.apiError(code: 10, message: "Invalid API key")
        #expect(apiError.errorDescription == "API error 10: Invalid API key")
    }
}
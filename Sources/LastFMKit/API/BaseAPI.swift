import Foundation

public class BaseAPI {
    public let baseURL: URL
    public let networkClient: NetworkClientProtocol
    
    public init(baseURL: URL, networkClient: NetworkClientProtocol) {
        self.baseURL = baseURL
        self.networkClient = networkClient
    }
    
    func buildEndpoint(
        category: String,
        method: String,
        parameters: [String: String] = [:],
        httpMethod: HTTPMethod = .get
    ) -> Endpoint {
        let path = "\(category)/\(method)"
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return Endpoint(
            path: path,
            method: httpMethod,
            queryItems: queryItems,
            baseURL: baseURL
        )
    }
}
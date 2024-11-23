// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public protocol NetworkService {
    func setEnvironment(_ environment: NetworkEnvironmentProvider)
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: [String: String]?,
        body: Data?
    ) -> AnyPublisher<T, Error>
}

public class NetworkManager: NetworkService {
    // public nonisolated(unsafe) static let shared = NetworkManager()
    private var networkConfiguration: NetworkConfiguration

    // private init() {}

    public init(networkConfiguration: NetworkConfiguration) {
        self.networkConfiguration = networkConfiguration
    }

    public func setEnvironment(_ environment: NetworkEnvironmentProvider) {
        networkConfiguration.setEnvironment(environment)
    }

    public func setHeaders(_ headers: NetworkHeadersProvider) {
        networkConfiguration.setHeaders(headers)
    }

    private func request<T: Decodable>(endPoint: EndPoint) -> AnyPublisher<T, Error> {
        guard let url = buildURL(for: endPoint) else { return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher() }
        let request = buildRequest(for: endPoint, url: url)

        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveSubscription: { _ in print("Request started") },
                              receiveOutput: { _ in print("Response received") },
                              receiveCompletion: { completion in print("Completion: \(completion)") },
                              receiveCancel: { print("Request canceled") })
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    public func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) -> AnyPublisher<T, Error> {
        let endPoint = buildEndPoint(path: path, method: method, parameters: parameters, headers: headers, body: body)
        guard let url = buildURL(for: endPoint) else { return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher() }
        let request = buildRequest(for: endPoint, url: url)

        /* return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveSubscription: { _ in print("Request started") },
                          receiveOutput: { _ in print("Response received") },
                          receiveCompletion: { completion in print("Completion: \(completion)") },
                          receiveCancel: { print("Request canceled") })
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher() */


        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(
                receiveSubscription: { _ in print("Request started") },
                receiveOutput: { _, response in
                    print("Response received: \(response)")
                },
                receiveCompletion: { completion in
                    print("Completion: \(completion)")
                },
                receiveCancel: { print("Request canceled") }
            )
            .map(\.data) // Extract data from the tuple (data, response)
            .decode(type: T.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { decodedData in
                print("Decoded data: \(decodedData)") // Print decoded data here
            })
            .eraseToAnyPublisher()
    }

    private func buildEndPoint(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) -> DynamicEndPoint {
        DynamicEndPoint(path: path, method: method, parameters: parameters, headers: headers, body: body)
    }

    private func buildURL<T: EndPoint>(for endPoint: T) -> URL? {
        let urlString = networkConfiguration.environment.baseURL + endPoint.path
        return URL(string: urlString)
    }

    private func buildRequest<T: EndPoint>(for endPoint: T, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        var allHeaders = networkConfiguration.headers.defaultHeaders
        if let endPointHeaders = endPoint.headers {
            allHeaders.merge(endPointHeaders) { (_, new) in new }
        }
        request.allHTTPHeaderFields = allHeaders
        if let parameters = endPoint.parameters {
            if endPoint.method == .get {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                request.url = urlComponents?.url
            } else if endPoint.method == .post || endPoint.method == .put {
                request.httpBody = endPoint.body
            }
        }
        return request
    }
}

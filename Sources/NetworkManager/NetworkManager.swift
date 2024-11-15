// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public protocol NetworkService {
    func setEnvironment(_ environment: EnvironmentProvider)
    func request<T: Decodable>(endPoint: EndPoint) -> AnyPublisher<T, Error>
}

public class NetworkManager: NetworkService {
    // public nonisolated(unsafe) static let shared = NetworkManager()
    private var headersProvider: HeadersProvider
    private var environmentProvider: EnvironmentProvider

    // private init() {}

    public init(headersProvider: HeadersProvider, environmentProvider: EnvironmentProvider) {
        self.headersProvider = headersProvider
        self.environmentProvider = environmentProvider
    }

    public func setEnvironment(_ environment: EnvironmentProvider) {
        self.environmentProvider = environment
    }

    public func request<T: Decodable>(endPoint: EndPoint) -> AnyPublisher<T, Error> {
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

    private func buildURL<T: EndPoint>(for endPoint: T) -> URL? {
        let urlString = environmentProvider.baseURL + endPoint.path
        return URL(string: urlString)
    }

    private func buildRequest<T: EndPoint>(for endPoint: T, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        var allHeaders = headersProvider.defaultHeaders
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

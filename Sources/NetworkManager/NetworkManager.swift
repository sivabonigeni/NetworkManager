// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public class NetworkManager {
    public nonisolated(unsafe) static let shared = NetworkManager()
    let environment: Environment = .development

    private init() {}

    public func request<T: Decodable>(endPoint: EndPoint) -> AnyPublisher<T, Error> {
        let url = buildURL(for: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers

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

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func buildURL<T: EndPoint>(for endPoint: T) -> URL {
        let baseURL = URL(string: environment.baseURL)!
        return baseURL.appendingPathComponent(endPoint.path)
    }
}

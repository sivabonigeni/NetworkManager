//
//  HTTPMethod.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: Error {
    case decodingError
    case invalidURL
    case serverError(statusCode: Int)
    case custom(message: String)
}

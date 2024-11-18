//
//  EndPoint.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}


struct DynamicEndPoint: EndPoint {
    var path: String
    var method: HTTPMethod
    var parameters: [String: Any]?
    var headers: [String: String]?
    var body: Data?
}

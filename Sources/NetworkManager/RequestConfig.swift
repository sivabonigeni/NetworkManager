//
//  RequestConfig.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

struct RequestConfig {
    let endpoint: EndPoint
    let method: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: Any]?
    let body: Data?

    init(endPoint: EndPoint) {
        self.endpoint = endPoint
        self.method = endPoint.method
        self.headers = endPoint.headers
        self.parameters = endPoint.parameters
        self.body = endPoint.body
    }

}

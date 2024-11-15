//
//  File.swift
//  NetworkManager
//
//  Created by Siva on 15/11/24.
//

import Foundation

public protocol HeadersProvider {
    var defaultHeaders: [String: String] { get }
    func updateHeader(key: String, value: String)
    func removeHeader(key: String)
}

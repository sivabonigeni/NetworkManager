//
//  File.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

public struct NetworkConfiguration {
    nonisolated(unsafe) public static var defaultHeaders: [String: String] = [:]
    nonisolated(unsafe) public static var defaultTimeout: TimeInterval = 10
    nonisolated(unsafe) public static var defaultRetryCount: Int = 3

    public static func configure(
        headers: [String: String] = defaultHeaders,
        timeout: TimeInterval = defaultTimeout,
        retryCount: Int = defaultRetryCount
    ) {
        defaultHeaders = headers
        defaultTimeout = timeout
        defaultRetryCount = retryCount
    }
}

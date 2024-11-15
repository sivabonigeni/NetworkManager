//
//  File.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

public protocol NetworkEnvironmentProvider {
    var baseURL: String { get }
}

public protocol NetworkHeadersProvider {
    var defaultHeaders: [String: String] { get }
    func updateHeader(key: String, value: String)
    func removeHeader(key: String)
}

public protocol NetworkTimeoutProvider {
    var timeout: TimeInterval { get }
}

public protocol NetworkRetryProvider {
    var retryCount: Int { get }
    var retryDelay: TimeInterval { get }
    func shouldRetry(after attempt: Int) -> Bool
}


public struct NetworkConfiguration {
    public var environment: NetworkEnvironmentProvider
    public let headers: NetworkHeadersProvider
    public let timeout: NetworkTimeoutProvider
    public let retry: NetworkRetryProvider

    public init(
        environment: NetworkEnvironmentProvider,
        headers: NetworkHeadersProvider,
        timeout: NetworkTimeoutProvider = DefaultNetworkTimeoutProvider(),
        retry: NetworkRetryProvider = DefaultNetworkRetryProvider()
    ) {
        self.environment = environment
        self.headers = headers
        self.timeout = timeout
        self.retry = retry
    }

    public mutating func setEnvironment(_ environment: NetworkEnvironmentProvider) {
        self.environment = environment
    }
}


// DefaultTimeout & Retry providers
public struct DefaultNetworkTimeoutProvider: NetworkTimeoutProvider {
    public var timeout: TimeInterval

    public init(timeout: TimeInterval = 10.0) {
        self.timeout = timeout
    }
}

public struct DefaultNetworkRetryProvider: NetworkRetryProvider {
    public var retryCount: Int
    public var retryDelay: TimeInterval

    public init(retryCount: Int = 3, retryDelay: TimeInterval = 2.0) {
        self.retryCount = retryCount
        self.retryDelay = retryDelay
    }

    public func shouldRetry(after attempt: Int) -> Bool {
        return attempt < retryCount
    }
}


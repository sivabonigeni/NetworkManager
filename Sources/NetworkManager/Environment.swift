//
//  File.swift
//  NetworkManager
//
//  Created by Siva on 14/11/24.
//

import Foundation

enum Environment {
    case development
    case production
    case staging

    var baseURL: String {
        switch self {
        case .development:
            return "https://api.github.com"
        case .production:
            return "https://api.github.com"
        case .staging:
            return "https://api.github.com"
        }
    }
}

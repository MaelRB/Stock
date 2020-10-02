//
//  RestError.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation

enum RestError {
    case noInternetConnection
    case custom(String)
    case other
}

extension RestError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noInternetConnection:
                return "No internet connection"
            case .custom(let message):
                return message
            case .other:
                return "Something went wrong but we don't know what"
        }
    }
}

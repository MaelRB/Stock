//
//  UrlExtension.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation

typealias Param = [String: Any]

extension URL {
    init(baseUrl: String, path: String, parameters: Param) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        self = components.url!
    }
}

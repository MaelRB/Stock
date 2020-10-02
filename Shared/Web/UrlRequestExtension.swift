//
//  UrlRequestExtension.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation

extension URLRequest {
    init(baseUrl: String, path: String, parameters: Param) {
        let url = URL(baseUrl: baseUrl, path: path, parameters: parameters)
        print(url)
        self.init(url: url)
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

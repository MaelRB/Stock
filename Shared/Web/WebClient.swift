//
//  WebClient.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation
import Network

final class WebClient {
    
    
    private var baseUrl: String
    
    init(url: String) {
        baseUrl = url
    }
    
    func load(path: String = "", parameters: Param, completion: @escaping (Any?, RestError?) -> ()) -> URLSessionDataTask? {
        
//        #if !targetEnvironment(simulator)
//        if NWPathMonitor().currentPath.status == .unsatisfied {
//            completion(nil, .noInternetConnection)
//            return nil
//        }
//        #endif
        
        print("path \(path)")
        
        let request = URLRequest(baseUrl: baseUrl, path: path, parameters: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                completion(data, nil)
            } else {
                completion(data, error != nil ? .custom(error!.localizedDescription) : .other)
            }
        }
        
        task.resume()
        
        return task
    }
}

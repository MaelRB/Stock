//
//  WebClient.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation
import Network

final class WebClient {
    private var token = "pk_16a20865e8d0409aa46f7a6866294093"
    private var baseUrl: String?
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func load(path: String, parameters: Param, completion: @escaping (Any?, RestError?) -> ()) -> URLSessionDataTask? {
        
//        #if !targetEnvironment(simulator)
//        if NWPathMonitor().currentPath.status == .unsatisfied {
//            completion(nil, .noInternetConnection)
//            return nil
//        }
//        #endif
        
        var params = parameters
        params["token"] = token
        
        print("path \(path)")
        
        let request = URLRequest(baseUrl: baseUrl!, path: path, parameters: params)
        
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

//
//  WebClient.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation
import Network

final class WebClient {
    private let token = "pk_16a20865e8d0409aa46f7a6866294093"
    private let url = "https://cloud.iexapis.com/stable"
    
    private let sandboxToken = "Tpk_a19783743d834721ae3d35fabda57cc1"
    private let sandboxUrl = "https://sandbox.iexapis.com/stable"
    
    private var baseToken: String
    private var baseUrl: String?
    
    init(sandBox: Bool) {
        if sandBox {
            self.baseToken = sandboxToken
            self.baseUrl = sandboxUrl
        } else {
            self.baseToken = token
            self.baseUrl = url
        }
    }
    
    init(url: String, token: String) {
        baseUrl = url
        baseToken = token
    }
    
    func load(path: String, parameters: Param, completion: @escaping (Any?, RestError?) -> ()) -> URLSessionDataTask? {
        
//        #if !targetEnvironment(simulator)
//        if NWPathMonitor().currentPath.status == .unsatisfied {
//            completion(nil, .noInternetConnection)
//            return nil
//        }
//        #endif
        
        var params = parameters
        params["token"] = baseToken
        
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

//
//  SearchService.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

class SearchService {
    
    private let client = WebClient(url: FMPurl)
    
    var urlSessionTask: URLSessionDataTask? = nil
    
    func fetch(for params: Param, completion: @escaping ([SearchSymbol]?, Error?) -> ()) {
        
        urlSessionTask?.cancel()
        
        urlSessionTask = client.load(parameters: params) { (result, error) in
            var searchSymbolList: [SearchSymbol]? = nil
            if let data = result as? Data {
                searchSymbolList = self.decode(data) 
            }
            completion(searchSymbolList, error)
        }
    }
    
    private func decode(_ data: Data) -> [SearchSymbol]? {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([SearchSymbol].self, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    
}

//
//  SearchService.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

class SearchService {
    
    private let client = WebClient(url: FMPurl)
    private let stocksService = StocksService()
    
    var urlSessionTask: URLSessionDataTask? = nil
    
    func fetch(for params: Param, completion: @escaping ([SearchResult]?, Error?) -> ()) {
        
        urlSessionTask?.cancel()
        
        urlSessionTask = client.load(parameters: params) { (result, error) in
            if let data = result as? Data {
                let searchSymbolList = self.decode(data)
                if let safeList = searchSymbolList {
                    self.fetchMarketInfo(for: safeList) { (result) in
                        completion(result, error)
                    }
                } else {
                    completion(nil, error)
                }
                
            } else {
                completion(nil, error)
            }
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
    
    private func fetchMarketInfo(for symbolList: [SearchSymbol], completion: @escaping ([SearchResult]) -> ()) {
        var searchResult = [SearchResult?]() {
            didSet {
                if searchResult.count == symbolList.count {
                    searchResult.removeAll { $0 == nil }
                    
                    var result: [SearchResult] = []
                    searchResult.forEach { result.append($0!)}
                    completion(result)
                }
            }
        }
        
        for symbol in symbolList {
            stocksService.fetchMarketInfo(for: symbol.symbol.lowercased()) { (quote, error) in
                if error != nil {
                    print(error!)
                } else if let safeQuote = quote {
                    searchResult.append(SearchResult(symbolSearch: symbol, marquetInfo: safeQuote))
                } else {
                    searchResult.append(nil)
                }
            }
        }
        
    }
    
}

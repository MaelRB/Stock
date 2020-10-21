//
//  StocksService.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation

final class StocksService {
    let client = WebClient(url: IEXsandboxUrl)
    
    func fetchMarket(for symbol: String, completion: @escaping (SymbolMarket?) -> ()) {
        var symbolMarket = SymbolMarket(symbolName: symbol) {
            didSet {
                if symbolMarket.isComplete() {
                    completion(symbolMarket)
                }
            }
        }
        
        fetchMarketInfo(for: symbol) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                // To do : handle error
            } else if let quote = result {
                symbolMarket.marketInfo = quote
            }
        }
        
        fetchLogo(for: symbol) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                // To do : handle error
            } else if let url = result {
                symbolMarket.logo = url
            }
        }
    }
    
    @discardableResult
    func fetchMarketInfo(for symbol: String, completion: @escaping (MarketQuote?, RestError?) -> ()) -> URLSessionDataTask? {
        
        let parameters: Param = ["displayPercent": true, "token": IEXsandboxToken]
        
        return client.load(path: "/stock/\(symbol)/quote", parameters: parameters) { result, error in
            var quote: MarketQuote? = nil
            if let data = result as? Data {
                quote = self.parseMarketQuote(data)
            }
            completion(quote, error)
        }
    }
    
    @discardableResult
    func fetchLogo(for symbol: String, completion: @escaping (URL?, RestError?) -> ()) -> URLSessionDataTask? {
        
        let parameters: Param = ["token": IEXsandboxToken]
        
        return client.load(path: "/stock/\(symbol)/logo", parameters: parameters) { result, error in
            var url: URL? = nil
            if let data = result as? Data {
                url = self.parseSymbolLogo(data)
            }
            completion(url, error)
        }
    }
    
    private func parseStockPrice(_ data: Data) -> [StockPrice]? {
        let decoder = JSONDecoder()
        do {
            let stocks = try decoder.decode([StockPrice].self, from: data)
            return stocks
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func parseMarketQuote(_ data: Data) -> MarketQuote? {
        let decoder = JSONDecoder()
        do {
            let quote = try decoder.decode(MarketQuote.self, from: data)
            return quote
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func parseSymbolLogo(_ data: Data) -> URL? {
        let decoder = JSONDecoder()
        do {
            let urlDico = try decoder.decode([String: String].self, from: data)
            guard let stringUrl = urlDico["url"] else { return nil }
            return URL(string: stringUrl)
        }
        catch {
            print(error)
            return nil
        }
    }
}

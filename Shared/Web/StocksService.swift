//
//  StocksService.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import Foundation

struct SymbolMarket: Identifiable {
    let id = UUID()
    var show: Bool = false
    var isMaxZ = false
    var symbolName: String
    var stockPriceList: [StockPrice]?
    var marketInfo: MarketQuote?
    var logo: URL?
    
    func isComplete() ->Bool {
        return stockPriceList != nil && marketInfo != nil && logo != nil
    }
}

final class StockServices {
    let client = WebClient(baseUrl: "https://cloud.iexapis.com/stable")
    
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
        
        fetchMarketChart(for: symbol) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                // To do : handle error
            } else if let list = result {
                symbolMarket.stockPriceList = list
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
    func fetchMarketChart(for symbol: String, completion: @escaping ([StockPrice]?, RestError?) -> ()) -> URLSessionDataTask? {
        
        let parameters: Param = [:]
        
        return client.load(path: "/stock/\(symbol)/intraday-prices", parameters: parameters) { result, error in
            var stocks: [StockPrice]? = nil
            if let data = result as? Data {
                stocks = self.parseStockPrice(data)
                if let list = stocks {
                    stocks = self.removeUselessIntradayPrices(list)
                }
            }
            completion(stocks, error)
        }
    }
    
    @discardableResult
    func fetchMarketInfo(for symbol: String, completion: @escaping (MarketQuote?, RestError?) -> ()) -> URLSessionDataTask? {
        
        let parameters: Param = ["displayPercent": true]
        
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
        
        let parameters: Param = [:]
        
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
    
    private func removeUselessIntradayPrices(_ list: [StockPrice]) -> [StockPrice] {
        var copyList = list
        copyList.removeAll {
            if $0.average == nil {
                return true
            } else {
                return $0.minute?.last! != "0" && $0.minute?.last! != "5"
            }
        }
        return copyList
    }
}

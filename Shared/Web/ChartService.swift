//
//  ChartService.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 11/10/2020.
//

import Foundation

enum ChartRange: String {
    case daily
    case fiveDays = "5dm"
    case monthly = "1m"
    case threeMonths = "3m"
    case sixMonths = "6m"
    case oneYear = "1y"
    case twoYears = "2y"
}

class ChartService {
    let client = WebClient(sandBox: true)
    var urlSessionTask: URLSessionDataTask? = nil
    
    func fetchMarketChart(for symbol: String, range: ChartRange, completion: @escaping ([StockPrice]?, RestError?) -> ()) {
        
        urlSessionTask?.cancel()
        
        let parameters: Param = [:]
        
        if range == .daily {
            urlSessionTask = client.load(path: "/stock/\(symbol)/intraday-prices", parameters: parameters) { result, error in
                let completionInfo = self.manageResult(result: result, error: error, for: range)
                completion(completionInfo.0, completionInfo.1)
            }
        } else {
            urlSessionTask = client.load(path: "/stock/\(symbol)/chart/\(range.rawValue)", parameters: parameters) { result, error in
                let completionInfo = self.manageResult(result: result, error: error, for: range)
                completion(completionInfo.0, completionInfo.1)
            }
        }
    }
    
    private func manageResult(result: Any?, error: RestError?, for range: ChartRange) -> ([StockPrice]?, RestError?) {
        var stocks: [StockPrice]? = nil
        if let data = result as? Data {
            stocks = self.parseStockPrice(data)
            if let list = stocks {
                stocks = self.removeUselessChartPrice(in: list, for: range)
            }
        }
        return (stocks, error)
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
    
    private func removeUselessChartPrice(in list: [StockPrice], for range: ChartRange) -> [StockPrice] {
        if range == .daily {
            return removeUselessDailyChartPrice(in: list)
        } else if range == .fiveDays {
            return removeUselessFiveDaysChartPrice(in: list)
        } else {
            return list
        }
    }
    
    private func removeUselessDailyChartPrice(in list: [StockPrice]) -> [StockPrice] {
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
    
    private func removeUselessFiveDaysChartPrice(in list: [StockPrice]) -> [StockPrice] {
        var copyList = list
        copyList.removeAll {
            if $0.average == nil {
                return true
            } else {
                return (($0.minute?.hasSuffix("50")) != nil)
            }
        }
        return copyList
    }
}

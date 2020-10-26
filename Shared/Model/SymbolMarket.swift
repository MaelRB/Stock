//
//  SymbolMarket.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 14/10/2020.
//

import Foundation

struct SymbolMarket: Identifiable {
    let id = UUID()
    var show: Bool = false
    var symbolName: String
    var marketInfo: MarketQuote?
    var logo: URL?
    
    private let cache = Cache<ChartRange, [StockPrice]>()
    
    func isComplete() ->Bool {
        return marketInfo != nil && logo != nil
    }
    
    func getPriceList(for range: ChartRange) -> [StockPrice]? {
        return cache[range]
    }
    
    func setPriceList(with value: [StockPrice], for range: ChartRange) {
        cache[range] = value
    }
}

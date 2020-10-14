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
    var isMaxZ = false
    var symbolName: String
    var stockPriceList: [StockPrice]?
    var marketInfo: MarketQuote?
    var logo: URL?
    
    func isComplete() ->Bool {
        return marketInfo != nil && logo != nil
    }
}

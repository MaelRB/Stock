//
//  Utilities.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

let screen = UIScreen.main.bounds

let defaultSymbolMarket = SymbolMarket(symbolName: "aapl", stockPriceList: defaultStockList, marketInfo: MarketQuote(companyName: "Alphabet, inc", latestPrice: 116.0, changePercent: -1.14, marketCap: 2000000000), logo: URL(string: "https://storage.googleapis.com/iex/api/logos/AAPL.png"))

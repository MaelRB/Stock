//
//  Utilities.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

let screen = UIScreen.main.bounds

let defaultSymbolMarket = SymbolMarket(symbolName: "aapl", marketInfo: MarketQuote(companyName: "Alphabet, incorporate incoofrgj", latestPrice: 116.0, changePercent: -1.14, marketCap: 1993068050089, volume: 1896415, high: 117.7, low: 114.9), logo: URL(string: "https://storage.googleapis.com/iex/api/logos/AAPL.png"))

// Used to fetch for market information like stock, historics...
let IEXtoken = "pk_16a20865e8d0409aa46f7a6866294093"
let IEXurl = "https://cloud.iexapis.com/stable"

let IEXsandboxToken = "Tpk_a19783743d834721ae3d35fabda57cc1"
let IEXsandboxUrl = "https://sandbox.iexapis.com/stable"


// Used for search a symbol market
let FMPtoken = "ad8e404ddeec4cd7f3a1130bdf833e21"
let FMPurl = "https://financialmodelingprep.com/api/v3/search"

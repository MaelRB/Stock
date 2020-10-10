//
//  MarketQuote.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 01/10/2020.
//

import UIKit

struct MarketQuote: Codable {
    let companyName: String
    let latestPrice: CGFloat
    let changePercent: CGFloat
    let marketCap: Int
    let volume: Int
    let high: CGFloat
    let low: CGFloat
}

enum QuoteKind: String {
    case marketCap = "Market captitalization"
    case low = "Low"
    case high = "High"
    case volume = "Volume"
}

//
//  SearchSymbolswift.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

struct SearchSymbol: Codable, Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let exchangeShortName: String
}

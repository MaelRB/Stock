//
//  StockPrice.swift
//  Stock (iOS)
//
//  Created by Mael Romanin Bluteau on 29/09/2020.
//

import UIKit

struct StockPrice: Codable {
    let id = UUID()
    let minute: String?
    let average: CGFloat?
}

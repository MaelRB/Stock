//
//  UserDefaultExtension.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 30/09/2020.
//

import Foundation

extension UserDefaults {
    private var symbolKey: String { "SymbolKey" }
    func symbol() -> [Any]? {
        return self.array(forKey: symbolKey)
    }
}

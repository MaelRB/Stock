//
//  HomeLogic.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 30/09/2020.
//

import Foundation

class HomeLogic: ObservableObject {
    @Published var symbolMarketList = [SymbolMarket]() {
        didSet {
            self.checkIfAllSymbolAreLoads()
        }
    }
    var isFinishingLoading = false
    
    private var symbolList = [String]()
    
    init() {
//        loadSymbol() / For now I will used hard coded values since I have not create a way to follow a symbol
        symbolList = ["aapl", "tsla", "goog"]
        fetchDataForSymbols()
    }
    
    
    private func loadSymbol() {
        let defaults = UserDefaults.standard
        if let symbolList = defaults.symbol() as? [String] {
            self.symbolList = symbolList
        }
    }
    
    private func fetchDataForSymbols() {
        for symbol in self.symbolList {
            fetchMarket(for: symbol)
        }
    }
    
    private func fetchMarket(for symbol: String) {
        StockServices().fetchMarket(for: symbol) { [self] result in
            if let symbolMarket = result {
                DispatchQueue.main.async {
                    self.symbolMarketList.append(symbolMarket)
                }
            }
        }
    }
    
    private func checkIfAllSymbolAreLoads() {
        isFinishingLoading = symbolMarketList.count == symbolList.count
    }
}



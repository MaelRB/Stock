//
//  StockView.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 07/10/2020.
//

import SwiftUI

struct StockView: View {
    var symbolMarket: SymbolMarket
    
    var body: some View {
        VStack {
            StockCellView(show: .constant(true), isMaxZ: .constant(true), isShowing: .constant(true), currentSymbolMarket: .constant(nil), canShowStockView: .constant(true), symbolMarket: symbolMarket)
            Spacer()
        }
        .background(Color.white)
        
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbolMarket: defaultSymbolMarket)
    }
}

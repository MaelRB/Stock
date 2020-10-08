//
//  StockView.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 07/10/2020.
//

import SwiftUI

struct StockView: View {
    var symbolMarket: SymbolMarket
    @State var isAppear = false
    @State private var showCardInfo: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                StockCellView(show: .constant(true), isMaxZ: .constant(true), isShowing: .constant(true), currentSymbolMarket: .constant(nil), canShowStockView: .constant(true), symbolMarket: symbolMarket)
                Spacer()
            }
            .blur(radius: showCardInfo ? 20 : 0)
            .animation(.linear)
            
            StockCardInfo(show: $showCardInfo, symbolMarket: .constant(symbolMarket))
                .offset(x: 0, y: self.isAppear ? -44 : 300)
                .animation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0))
        }
        .background(Color.white)
        .onAppear(perform: {
            isAppear.toggle()
        })
        
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbolMarket: defaultSymbolMarket)
    }
}

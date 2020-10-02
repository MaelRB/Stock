//
//  Home.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

struct Home: View {
    @State private var active = false
    @State private var stocks = stockData
    @State private var isShowingCardInfo = false
    @ObservedObject var homeLogic = HomeLogic()
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ZStack {
                        HStack {
                            Text("Stock")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                                .opacity(self.active ? 0 : 1)
                                .offset(x: self.active ? -100 : 0, y: 0)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Button(action: {
                                self.active.toggle()
                                desactiveCard()
                            }, label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .opacity(self.active ? 1 : 0)
                                    .offset(x: self.active ? 0 : -100, y: 0)
                                    .padding()
                            })
                            
                            Spacer()
                        }
                    }
                    
                    if homeLogic.isFinishingLoading {
                        ForEach(stocks.indices) { index in
                            GeometryReader { geo in
                                StockCellView(show: self.$stocks[index].show, active: $active, symbolMarket: homeLogic.symbolMarketList[index])
                                    .offset(x: 0, y: self.stocks[index].show ? -geo.frame(in: .global).minY + 120 : 0)
                            }
                            .frame(width: screen.width - 30, height: 140)
                            .frame(maxHeight: self.stocks[index].show ? .infinity : 140)
                            .zIndex(self.stocks[index].show ? 1 : 0)
                            .offset(x: isNotShowing(index) ? screen.width : 0, y: 0)
                            .opacity(isNotShowing(index) ? 0 : 1)
                            
                        }
                    }
                    
                    
                    Spacer()
                }
            }
            .blur(radius: isShowingCardInfo ? 20 : 0)
            .animation(.easeInOut)
            
            StockCardInfo(show: $isShowingCardInfo)
                .offset(x: 0, y: self.active ? 0 : 300)
                .opacity(self.active ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        }
    }
    
    private func isNotShowing(_ index: Int) -> Bool {
        return self.stocks[index].show == false && active
    }
    
    private func desactiveCard() {
        for i in 0..<stocks.count {
            stocks[i].show = false
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Stock: Identifiable {
    var id = UUID()
    var show: Bool
}

let stockData = [Stock(show: false), Stock(show: false), Stock(show: false)]

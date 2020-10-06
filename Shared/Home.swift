//
//  Home.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

struct Home: View {
    @State private var active = false
    @State private var isShowingCardInfo = false
    @State private var currentSymbolMarket: SymbolMarket? = nil
    @ObservedObject var homeLogic = HomeLogic()
    
    var body: some View {
        GeometryReader { geoProxy in
            ZStack {
                VStack {
                    NavigtionBarView(active: $active, symbolMarketList: $homeLogic.symbolMarketList)
                        .animation(Animation.easeInOut)
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 140) {
                        
                        if homeLogic.isFinishingLoading {
                            ForEach(homeLogic.symbolMarketList.indices) { index in
                                GeometryReader { geo in
                                    StockCellView(
                                        show: self.$homeLogic.symbolMarketList[index].show,
                                        active: $active,
                                        currentSymbolMarket: $currentSymbolMarket,
                                        symbolMarket: homeLogic.symbolMarketList[index]
                                    )
                                    .offset(x: 15, y: self.homeLogic.symbolMarketList[index].show ? -geo.frame(in: .global).minY + 45 + geoProxy.safeAreaInsets.top : 45 + geoProxy.safeAreaInsets.top)
                                    .animation(.easeInOut(duration: 0.5))
                                    
                                }
                                .frame(maxHeight: 140)
                                .zIndex(self.homeLogic.symbolMarketList[index].show ? 1 : 0)
                                .offset(x: isNotShowing(index) ? screen.width : 0, y: isNotShowing(index) ? 0 : 0)
                                .opacity(isNotShowing(index) ? 0 : 1)
                                .animation(.easeInOut)
                            }
                        }
                    }
                }
                .blur(radius: isShowingCardInfo ? 20 : 0)
            }
        }
    }
    
    private func isNotShowing(_ index: Int) -> Bool {
        return self.homeLogic.symbolMarketList[index].show == false && active
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

struct NavigtionBarView: View {
    @Binding var active: Bool
    @Binding var symbolMarketList: [SymbolMarket]
    
    var body: some View {
        VStack {
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
                            .foregroundColor(Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .opacity(self.active ? 1 : 0)
                            .offset(x: self.active ? 0 : -100, y: 0)
                            .padding(.horizontal)
                            .padding(.top)
                    })
                    
                    Spacer()
                }
            }
            Divider()
                .opacity(self.active ? 0 : 1)
        }
        .frame(height: self.active ? 30 : 70)
        
    }
    
    private func desactiveCard() {
        for i in 0..<symbolMarketList.count {
            symbolMarketList[i].show = false
        }
    }
}

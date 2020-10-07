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
            VStack {
                NavigtionBarView(active: $active, symbolMarketList: $homeLogic.symbolMarketList)
                    .animation(.easeInOut)
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        if homeLogic.isFinishingLoading {
                            ForEach(homeLogic.symbolMarketList.indices) { index in
                                GeometryReader { geo in
                                    StockCellView(
                                        show: self.$homeLogic.symbolMarketList[index].show,
                                        isMaxZ: self.$homeLogic.symbolMarketList[index].isMaxZ,
                                        active: $active,
                                        currentSymbolMarket: $currentSymbolMarket,
                                        symbolMarket: homeLogic.symbolMarketList[index]
                                    )
                                    .offset(x: 15, y: self.homeLogic.symbolMarketList[index].show ? -geo.frame(in: .global).minY + 90 + geoProxy.safeAreaInsets.top : 0)
                                    
                                }
                                .offset(x: 0, y: CGFloat(Int(index) * 155))
                                .frame(maxHeight: 140)
                                .zIndex(self.homeLogic.symbolMarketList[index].isMaxZ ? 1 : 0)
                                .animation(.easeInOut)
                            }
                        }
                        
                        VStack {
                            Spacer()
                            Color(.white)
                                .frame(width: self.active ? screen.width : 0, height: self.active ? screen.height - 60 : 0, alignment: .center)
                                
                            Spacer()
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
        
    }
    
    private func desactiveCard() {
        for i in 0..<symbolMarketList.count {
            symbolMarketList[i].show = false
        }
    }
}

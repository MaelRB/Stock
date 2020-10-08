//
//  Home.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI
import Lottie

struct Home: View {
    @State private var isShowingStockView = false
    @State private var canShowStockView = false
    @State private var currentSymbolMarket: SymbolMarket? = nil
    @ObservedObject var homeLogic = HomeLogic()
    
    var body: some View {
        GeometryReader { geoProxy in
            VStack {
                NavigtionBarView(isShowing: $isShowingStockView, canShow: $canShowStockView, symbolMarketList: $homeLogic.symbolMarketList)
                    .animation(.easeInOut)
                
                if homeLogic.isFinishingLoading {
                    StockList(isShowingStockView: $isShowingStockView, canShowStockView: $canShowStockView, currentSymbolMarket: $currentSymbolMarket, homeLogic: homeLogic, geoProxy: geoProxy)
                } else {
                    VStack {
                        Spacer()
                        LottieView(fileName: "loading")
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                }
                
            }
        }
    }
    
    private func isNotShowing(_ index: Int) -> Bool {
        return self.homeLogic.symbolMarketList[index].show == false && isShowingStockView
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
    @Binding var isShowing: Bool
    @Binding var canShow: Bool
    @Binding var symbolMarketList: [SymbolMarket]
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("Stock")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .opacity(self.isShowing ? 0 : 1)
                        .offset(x: self.isShowing ? -100 : 0, y: 0)
                    
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        self.isShowing.toggle()
                        self.canShow.toggle()
                        desactiveCard()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .opacity(self.isShowing ? 1 : 0)
                            .offset(x: self.isShowing ? 0 : -100, y: 0)
                            .padding(.horizontal)
                            .padding(.top)
                    })
                    
                    Spacer()
                    
                }
            }
            Divider()
                .opacity(self.isShowing ? 0 : 1)
        }
        
    }
    
    private func desactiveCard() {
        for i in 0..<symbolMarketList.count {
            symbolMarketList[i].show = false
            symbolMarketList[i].isMaxZ = false
        }
    }
}

struct StockList: View {
    @Binding var isShowingStockView: Bool
    @Binding var canShowStockView: Bool
    @Binding var currentSymbolMarket: SymbolMarket?
    @ObservedObject var homeLogic: HomeLogic
    var geoProxy: GeometryProxy
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                ZStack {
                    
                    ForEach(homeLogic.symbolMarketList.indices) { index in
                        GeometryReader { geo in
                            StockCellView(
                                show: self.$homeLogic.symbolMarketList[index].show,
                                isMaxZ: self.$homeLogic.symbolMarketList[index].isMaxZ,
                                isShowing: $isShowingStockView,
                                currentSymbolMarket: $currentSymbolMarket,
                                canShowStockView: $canShowStockView,
                                symbolMarket: homeLogic.symbolMarketList[index]
                            )
                            .offset(x: 15, y: self.homeLogic.symbolMarketList[index].show ? -geo.frame(in: .global).minY + 90 + geoProxy.safeAreaInsets.top : 0)
                            
                        }
                        .offset(x: 0, y: CGFloat(Int(index) * 155))
                        .frame(maxHeight: 140)
                        .zIndex(self.homeLogic.symbolMarketList[index].isMaxZ ? 1 : 0)
                        .animation(.easeInOut)
                    }
                    
                    
                    VStack {
                        Spacer()
                        Color(.white)
                            .frame(width: self.isShowingStockView ? screen.width : 0, height: self.isShowingStockView ? screen.height - 60 : 0, alignment: .center)
                        
                        Spacer()
                    }
                }
            }
            .disabled(isShowingStockView)
            
            if canShowStockView {
                StockView(symbolMarket: currentSymbolMarket!)
            }
            
        }
    }
}

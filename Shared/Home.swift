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
    @State private var currentSymbolMarket: SymbolMarket? = defaultSymbolMarket
    @State private var showCardInfo = false
    @ObservedObject var homeLogic = HomeLogic()
    
    var body: some View {
        GeometryReader { geoProxy in
            VStack {
                NavigationBarView(isShowing: $isShowingStockView, symbolMarketList: $homeLogic.symbolMarketList, showCardInfo: $showCardInfo)
                    .animation(.easeInOut)
                
                if homeLogic.isFinishingLoading {
                    ZStack {
                        StockList(isShowingStockView: $isShowingStockView, currentSymbolMarket: $currentSymbolMarket, homeLogic: homeLogic, geoProxy: geoProxy)
                            .blur(radius: showCardInfo ? 20 : 0)
                            .animation(.linear)
                        
                        StockCardInfo(show: $showCardInfo, symbolMarket: $currentSymbolMarket)
                            .offset(x: 0, y: self.isShowingStockView ? -44 : 300)
                            .animation(.spring(response: 0.4, dampingFraction: 0.70, blendDuration: 0))
                    }
                    
                } else {
                    LoadingView()
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
        let home = Home()
        
        home.homeLogic.symbolMarketList = [defaultSymbolMarket, defaultSymbolMarket, defaultSymbolMarket]
        home.homeLogic.isFinishingLoading = true
        
        return Group {
            home
//            home
//                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
        }
    }
}


struct NavigationBarView: View {
    @Binding var isShowing: Bool
    @Binding var symbolMarketList: [SymbolMarket]
    @Binding var showCardInfo: Bool
    
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
                        if showCardInfo {
                            self.showCardInfo.toggle()
                        }
                        self.isShowing.toggle()
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
        }
    }
}

struct StockList: View {
    @Binding var isShowingStockView: Bool
    @Binding var currentSymbolMarket: SymbolMarket?
    @State private  var indexWithMaxZ: Int = 0
    @ObservedObject var homeLogic: HomeLogic
    var geoProxy: GeometryProxy
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 380), spacing: 20)]) {
                ForEach(homeLogic.symbolMarketList.indices) { index in
                    GeometryReader { geo in
                        StockCellView(
                            show: self.$homeLogic.symbolMarketList[index].show,
                            currentSymbolMarket: $currentSymbolMarket,
                            canShowStockView: $isShowingStockView,
                            symbolMarket: homeLogic.symbolMarketList[index]
                        )
                        .offset(x: 0, y: self.homeLogic.symbolMarketList[index].show ? -geo.frame(in: .global).minY + 90 + geoProxy.safeAreaInsets.top : 0)
                    }
                    .frame(height: 140)
                    .zIndex(indexWithMaxZ == index ? 1 : 0)
                    .opacity(self.homeLogic.symbolMarketList[index].show ? 1 : self.isShowingStockView ? 0 : 1)
                    .animation(.easeInOut)
                    .onTapGesture {
                        self.currentSymbolMarket = homeLogic.symbolMarketList[index]
                        self.homeLogic.symbolMarketList[index].show.toggle()
                        self.isShowingStockView.toggle()
                        self.indexWithMaxZ = index
                    }
                    .disabled(self.isShowingStockView)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .disabled(isShowingStockView)
            
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            LottieView(fileName: "loading")
                .frame(width: 200, height: 200)
            Spacer()
        }
    }
}

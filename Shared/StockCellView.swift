//
//  StockCellView.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

struct StockCellView: View {
    var lightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var darkColor = #colorLiteral(red: 0.8823529412, green: 0.8941176471, blue: 0.9215686275, alpha: 1)
    @Binding var show: Bool
    @Binding var active: Bool
    var symbolMarket: SymbolMarket
    
    var body: some View {
        ZStack {
            
            // Background
            Color(lightColor)
                .frame(width: screen.width - 30, height: self.show ? 490 : 140)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(lightColor), radius: 15, x: -10, y: -10)
                .shadow(color: Color(darkColor), radius: 5, x: 10, y: 10)
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    LogoView(lightColor: lightColor, darkColor: darkColor)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text(symbolMarket.marketInfo!.companyName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        
                        Text(symbolMarket.symbolName.uppercased())
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 14) {
                        Text("$\(symbolMarket.marketInfo!.latestPrice, specifier: "%2g")")
                            .font(.title3)
                            .fontWeight(.semibold)
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.up.right")
                            
                            Text("\(symbolMarket.marketInfo!.changePercent, specifier: "%2g")%")
                                .frame(width: 60)
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                    }
                    
                }
                .offset(x: 0, y: self.show ? 0 : 12)
                
                VStack(spacing: 30) {
                    Spacer()
                    StockChart(stockList: symbolMarket.stockPriceList!)
                    HStack(spacing: 40) {
                        ForEach(0 ..< 5) { item in
                            Text("1d")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .padding(.vertical, 20)
                }
                .frame(height: self.show ? 330 : 0)
                .opacity(self.show ? 1 : 0)
                .shadow(color: .white, radius: 10, x: 0, y: 0)
                
            }
            .padding(.horizontal, 20)
            .frame(width: screen.width - 40, height: self.show ? 480 : 130)
            .background(Color(#colorLiteral(red: 0.9482057691, green: 0.9529708028, blue: 0.9658263326, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
        .animation(Animation.spring(response: 0.4, dampingFraction: 0.65, blendDuration: 0).speed(1.2))
        .onTapGesture {
            self.show.toggle()
            self.active.toggle()
        }
    }
}

struct StockCellView_Previews: PreviewProvider {
    static var previews: some View {
        StockCellView(show: .constant(false), active: .constant(false), symbolMarket: SymbolMarket(symbolName: "appl", stockPriceList: defaultStockList))
    }
}


struct LogoView: View {
    var lightColor: UIColor
    var darkColor: UIColor
    var companyName: String = ""
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9482057691, green: 0.9529708028, blue: 0.9658263326, alpha: 1))
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0.0, y: 0.0)
                .shadow(color: Color(lightColor), radius: 4, x: -6, y: -6)
                .shadow(color: Color(darkColor), radius: 6, x: 10, y: 8)
            
            Image("apple")
                .renderingMode(.original)
        }
    }
}

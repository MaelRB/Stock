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
    @Binding var currentSymbolMarket: SymbolMarket?
    @Binding var canShowStockView: Bool
    var symbolMarket: SymbolMarket
    @State private var selectedRange: ChartRange = .daily
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                VStack(spacing: 20) {
                    HStack(spacing: 10) {
                        LogoView(lightColor: lightColor, darkColor: darkColor, symbolMarket: symbolMarket, bounds: bounds)
                            .padding(.leading, 20)
                        
                        CenterComponentView(symbolMarket: symbolMarket)
                            .padding(.leading, 20)
                        
                        Spacer()
                        
                        RightComponentView(marketInfo: symbolMarket.marketInfo!)
                            .padding(.trailing, 20)
                    }
                    .animation(.easeInOut)
                    .frame(height: 85)
                    .padding(.top, 20)
                    
                    VStack(spacing: 15) {
                        StockChart(symbolMarket: symbolMarket, show: $show)
                            .foregroundColor(symbolMarket.marketInfo!.changePercent ?? 0 < 0 ? Color(#colorLiteral(red: 0.9999999404, green: 0.1764707565, blue: 0.3333333135, alpha: 1)) : Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .animation(.easeInOut)
                    }
                    .frame(height: self.show ? 260 : 0)
                    .opacity(self.show ? 1 : 0)
                    
                }
            }
            .frame(width: bounds.size.width - 10, height: self.show ? 380 : 120)
            .background(Color(#colorLiteral(red: 0.9482057691, green: 0.9529708028, blue: 0.9658263326, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .frame(width: bounds.size.width, height: self.show ? 390 : 130)
            .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundColor(Color(lightColor))
                            .shadow(color: Color(lightColor), radius: 15, x: -10, y: -10)
                            .shadow(color: Color(darkColor), radius: 5, x: 10, y: 10)
            )
        }
        .frame(maxWidth: 370)
    }
}

struct StockCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StockCellView(show: .constant(true), currentSymbolMarket: .constant(defaultSymbolMarket), canShowStockView: .constant(false), symbolMarket: defaultSymbolMarket)
        }
    }
}


struct LogoView: View {
    var lightColor: UIColor
    var darkColor: UIColor
    var symbolMarket: SymbolMarket
    var bounds: GeometryProxy
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9482057691, green: 0.9529708028, blue: 0.9658263326, alpha: 1))
                .frame(width: bounds.size.width * 0.15, height: bounds.size.width * 0.15)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0.0, y: 0.0)
                .shadow(color: Color(lightColor), radius: 4, x: -6, y: -6)
                .shadow(color: Color(darkColor), radius: 6, x: 10, y: 8)
            
            Image(uiImage: loadImage() ?? UIImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 340 * 0.12, height: 340 * 0.12)
                .clipShape(Circle())
                .blendMode(.multiply)
        }
    }
    
    func loadImage() -> UIImage? {
        do {
            let imageData = try Data(contentsOf: symbolMarket.logo!)
            return UIImage(data: imageData)
        }
        catch {
            print("Couldn't load the image")
        }
        return nil
    }
}

struct CenterComponentView: View {
    var symbolMarket: SymbolMarket
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(symbolMarket.marketInfo!.companyName)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .lineLimit(3)
            
            Text(symbolMarket.symbolName.uppercased())
                .font(.callout)
        }
    }
}

struct RightComponentView: View {
    var marketInfo: MarketQuote
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            
            Text("$\(roundNumber(marketInfo.latestPrice ?? 0), specifier: "%g")")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            HStack(spacing: 8) {
                if marketInfo.changePercent ?? 0 < 0 {
                    Image(systemName: "arrow.down.right")
                } else {
                    Image(systemName: "arrow.up.right")
                }
                
                Text("\(roundNumber(marketInfo.changePercent ?? 0), specifier: "%g")%")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
            }
            .foregroundColor(marketInfo.changePercent ?? 0 < 0 ? Color(#colorLiteral(red: 0.9999999404, green: 0.1764707565, blue: 0.3333333135, alpha: 1)) : Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
        }
    }
    
    private func roundNumber(_ number: CGFloat) -> CGFloat {
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        return CGFloat(round(Double(number) * multiplier) / multiplier)
    }

}



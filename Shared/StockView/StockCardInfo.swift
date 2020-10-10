//
//  StockCardInfo.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 26/09/2020.
//

import SwiftUI

struct StockCardInfo: View {
    @Binding var show: Bool
    @State private var dragTranslation = CGSize.zero
    @State private var isDraging = false
    @Binding var symbolMarket: SymbolMarket?
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                RoundedRectangle(cornerRadius: 30).foregroundColor(Color(#colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.9647058824, alpha: 1)))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 5, y: self.show ? 10 : 20)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.1), radius: 5)
                    .offset(x: 0, y: 15)
                
                VStack {
                    StockCardInfoContentCell(show: $show, value: String(symbolMarket!.marketInfo!.volume), title: "Volume", imageName: "waveform.path.ecg")
                    StockCardInfoContentCell(show: $show, value: "\(symbolMarket!.marketInfo!.high)", title: "High price", imageName: "arrow.up.right")
                    StockCardInfoContentCell(show: $show, value: "\(symbolMarket!.marketInfo!.low)", title: "Low price", imageName: "arrow.down.right")
                }
                .offset(x: 0, y: self.show ? 80 : 0)
            }
            .frame(width: self.show ? screen.width - 40 : screen.width - 100, height: self.show ? 520 : 150)
            .opacity(self.show ? 1 : 0)
            
            StockCardInfoHeaderView(title: "Market capitalization", info: formattingCapitalizationValue(), systemImageName: "dollarsign.circle", color: #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1), show: $show, translation: $dragTranslation, isDraging: $isDraging)
                .offset(y: self.show ? self.dragTranslation.height / 35 : 0)
        }
        .scaleEffect(self.isDraging ? (1 - self.dragTranslation.height / 4000) : 1)
        .offset(x: 0, y: self.show ? 0 : 320)
    }
    
    private func formattingCapitalizationValue() -> String {
        guard let mkt = symbolMarket?.marketInfo?.marketCap else { return "" }
        if mkt >= 1_000_000_000_000 {
            let firstDigit: Int = mkt / 1_000_000_000_000
            let secondDigits: Int = (mkt - 1_000_000_000_000) / 1_000_000_000
            return "$\(firstDigit),\(secondDigits) T"
        } else if mkt >= 1_000_000_000 {
            let firstDigit: Int = mkt / 1_000_000_000
            let secondDigits: Int = (mkt - 1_000_000_000) / 10_000_000_000
            return "$\(firstDigit),\(secondDigits) B"
        } else {
            return "$\(mkt)"
        }
    }
    
}

struct StockVolumInfo_Previews: PreviewProvider {
    static var previews: some View {
        StockCardInfo(show: .constant(false), symbolMarket: .constant(defaultSymbolMarket))
    }
}


struct StockCardInfoHeaderView: View {
    var title: String
    var info: String
    var systemImageName: String
    var color: UIColor
    @Binding var show: Bool
    @Binding var translation: CGSize
    @Binding var isDraging: Bool
    
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .font(.system(size: 28, weight: .semibold))
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).foregroundColor(.white))
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                
                Text(info)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .frame(width: 200, alignment: .center)
            .padding(.leading, 10)
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .frame(width: self.show ? screen.width - 40: screen.width - 80)
        .frame(height: 150)
        .background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(color)))
        .shadow(color: Color(color).opacity(0.3), radius: 20, x: 5, y: self.show ? 10 : 20)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2), radius: 5)
        .onTapGesture {
            self.show.toggle()
        }
        .gesture(
            DragGesture().onChanged { value in
                self.translation = value.translation
                self.isDraging = true
            }
            .onEnded { value in
                self.translation = CGSize.zero
                self.isDraging = false
                if value.translation.height > 100 {
                    self.show = false
                }
            }
        )
    }
}

struct StockCardInfoContentCell: View {
    @Binding var show: Bool
    var value: String
    var title: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.system(size: 28, weight: .semibold))
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).foregroundColor(.white))
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .frame(width: 200, alignment: .center)
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .frame(height: self.show ? 120 : 50)
    }
}


//
//  StockChart.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 30/09/2020.
//

import SwiftUI

struct StockChart: View {
    var symbolMarket: SymbolMarket
    
    @State private var selectedRange: ChartRange = .daily
    @Binding var show: Bool
    
    var chartService = ChartService()
    
    @State private var strokeColor = #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)
    @State private var stockPriceList: [StockPrice] = []
    @State private var isLoading = true
    @State private var startTrim = false
    
    public var body: some View {
        VStack {
            if isLoading {
                LottieView(fileName: "loading")
                    .frame(width: 100, height: 100, alignment: .center)
            } else {
                LineGraph(dataPoints: stockPriceList.map { (($0.average ?? 0) - getMin()) / (self.getMax() - self.getMin()) })
                    .trim(to: startTrim ? 1 : 0)
                    .stroke(Color(strokeColor), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    .aspectRatio(16/9, contentMode: .fit)
                    .padding(.horizontal)
                    .animation(startTrim ? Animation.easeInOut(duration: 1) : nil)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    selectedRange = .daily
                    fetchNewStockPrice()
                }, label: {
                    Text("1D")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .daily))
                Button(action: {
                    selectedRange = .fiveDays
                    fetchNewStockPrice()
                }, label: {
                    Text("5D")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .fiveDays))
                Button(action: {
                    selectedRange = .monthly
                    fetchNewStockPrice()
                }, label: {
                    Text("1M")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .monthly))
                Button(action: {
                    selectedRange = .threeMonths
                    fetchNewStockPrice()
                }, label: {
                    Text("3M")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .threeMonths))
                Button(action: {
                    selectedRange = .sixMonths
                    fetchNewStockPrice()
                }, label: {
                    Text("6M")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .sixMonths))
                Button(action: {
                    selectedRange = .oneYear
                    fetchNewStockPrice()
                }, label: {
                    Text("1Y")
                })
                .buttonStyle(ChartButtonStyle(isSelected: selectedRange == .oneYear))
            }
            //        .animation(show ? nil : .easeInOut)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
            .padding(.vertical, 15)
            
        }
        .onAppear(perform: {
            self.fetchNewStockPrice()
            self.changeStrokeColor()
        })
        .animation(.easeInOut)
    
            
    }
    
    private func changeStrokeColor() {
        strokeColor = symbolMarket.marketInfo!.changePercent ?? 0 < 0 ? #colorLiteral(red: 0.9999999404, green: 0.1764707565, blue: 0.3333333135, alpha: 1) : #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)
    }
    
    private func getMin() -> CGFloat {
        var min: CGFloat = 100000
        for price in stockPriceList {
            if let average = price.average {
                if average < min {
                    min = price.average!
                }
            }
        }
        return min
    }
    
    private func getMax() -> CGFloat {
        var max: CGFloat = 0
        for price in stockPriceList {
            if let average = price.average {
                if average > max {
                    max = average
                }
            }
        }
        return max
    }
    
    private func fetchNewStockPrice() {
        if show {
            switchToLoadingState()
            DispatchQueue.main.async {
                self.getStockPrice()
            }
        }
    }
    
    private func switchToLoadingState() {
        guard show else { return }
        isLoading = true
        startTrim = false
    }
    
    private func switchToPresentationState(with priceList: [StockPrice]) {
        self.stockPriceList = priceList
        self.isLoading = false
        self.startTrimingAfterDelay()
    }
    
    
    // Should be executed on the main queue
    private func getStockPrice() {
        if let priceList = symbolMarket.getPriceList(for: selectedRange) {
            switchToPresentationState(with: priceList)
        } else {
            fetchStockPrice()
        }
        
    }
    
    private func fetchStockPrice() {
        chartService.fetchMarketChart(for: symbolMarket.symbolName, range: selectedRange) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                // To do : handle error
                self.isLoading = false
            } else if let priceList = result {
                self.symbolMarket.setPriceList(with: priceList, for: selectedRange)
                self.switchToPresentationState(with: priceList)
            }
        }
    }
    
    private func startTrimingAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startTrim = true
        }
    }
    
}

struct StockChart_Previews: PreviewProvider {
    static var previews: some View {
        StockChart(symbolMarket: defaultSymbolMarket, show: .constant(true))
    }
}

let defaultStockList = [
    StockPrice(minute: "", average: 104.36),
    StockPrice(minute: "", average: 104.80),
    StockPrice(minute: "", average: 105.36),
    StockPrice(minute: "", average: 104.96),
    StockPrice(minute: "", average: 105.12),
    StockPrice(minute: "", average: 105.53),
    StockPrice(minute: "", average: 104.36),
    StockPrice(minute: "", average: 104.80),
    StockPrice(minute: "", average: 105.36),
    StockPrice(minute: "", average: 104.96),
    StockPrice(minute: "", average: 105.12),
    StockPrice(minute: "", average: 105.53),
]

struct LineGraph: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }
        
        return Path { p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            for idx in dataPoints.indices {
                p.addLine(to: point(at: idx))
            }
        }
    }
}

struct ChartButtonStyle: ButtonStyle {
    
    var isSelected: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .foregroundColor(isSelected ? .white : .black)
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)) : .clear))
        
    }
}

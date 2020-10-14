//
//  StockChart.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 30/09/2020.
//

import SwiftUI

struct StockChart: View {
    var symbol: String
    @State private var selectedRange: ChartRange = .daily
    
    var chartService = ChartService()
    var strokeColor = #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)
    
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
        })
        .animation(.easeInOut)
    
            
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
        isLoading = true
        startTrim = false
        DispatchQueue.main.async {
            self.fetchStockPrice()
        }
    }
    
    
    // Should be executed on the main queue
    private func fetchStockPrice() {
        chartService.fetchMarketChart(for: symbol, range: selectedRange) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                // To do : handle error
                self.isLoading = false
            } else if let priceList = result {
                self.isLoading = false
                self.stockPriceList = priceList
                self.startTrimingAfterDelay()
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
        StockChart(symbol: "appl")
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


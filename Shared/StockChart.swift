//
//  StockChart.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 30/09/2020.
//

import SwiftUI

struct StockChart: View {
    var stockList: [StockPrice]
    var maxPrice: CGFloat = 0
    private var strokeColor = #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)
    
    var body: some View {
        
        LineGraph(dataPoints: stockList.map { ($0.average! - getMin()) / (self.maxPrice - self.getMin()) })
            .stroke(Color(strokeColor), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
            .aspectRatio(16/9, contentMode: .fit)
            .padding(.horizontal)
            
    }
    
    init(symbolMarket: SymbolMarket) {
        self.stockList = symbolMarket.stockPriceList!
        self.maxPrice = getMax()
        self.strokeColor = symbolMarket.marketInfo!.changePercent < 0 ? #colorLiteral(red: 0.9999999404, green: 0.1764707565, blue: 0.3333333135, alpha: 1) : #colorLiteral(red: 0.007843137255, green: 0.768627451, blue: 0.5843137255, alpha: 1)

    }
    
    private func getMin() -> CGFloat {
        var min: CGFloat = 100000
        for price in stockList {
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
        for price in stockList {
            if let average = price.average {
                if average > max {
                    max = average
                }
            }
        }
        return max
    }
}

struct StockChart_Previews: PreviewProvider {
    static var previews: some View {
        StockChart(symbolMarket: defaultSymbolMarket)
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

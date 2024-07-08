//
//  Prec1hChartView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import Charts

struct Prec1hChartView: View {
    
    let dataList:[PointItem]

    var body: some View {
        Chart(dataList) { data in
            BarMark(
                x: .value("Name", data.date),
                y: .value("Amount", data.prec1h)

            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .annotation(position: .top, alignment: .center, spacing: 10) {
                Text(String(format: "%.1f", data.prec1h))
                    .font(.caption)
                    .frame(width: 100, height: 40)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .minute, count: 10)){ date in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(anchor: UnitPoint(x: 0, y: -2))
            }
        }
        .foregroundColor(Color.blue)
        .frame(height: 200)
    }
}

#Preview {
   Prec1hChartView(dataList: [
    PointItem(temp: 23.4, wind: 25.0, windDirection: 13, prec1h: 23.1, date: Date()),
    PointItem(temp: 24.4, wind: 25.0, windDirection: 1, prec1h: 23.1, date: Date().addingTimeInterval(60)),
    PointItem(temp: 25.0, wind: 25.0, windDirection: 0, prec1h: 23.1, date: Date().addingTimeInterval(120)),
    PointItem(temp: 26.0, wind: 25.0, windDirection: 10, prec1h: 23.1, date: Date().addingTimeInterval(180)),
    PointItem(temp: 27.4, wind: 25.0, windDirection: 4, prec1h: 23.1, date: Date().addingTimeInterval(240)),
    PointItem(temp: 25.8, wind: 25.0, windDirection: 5, prec1h: 23.1, date: Date().addingTimeInterval(300)),
    PointItem(temp: 26.4, wind: 25.0, windDirection: 8, prec1h: 23.1, date: Date().addingTimeInterval(360)),
   ])
}

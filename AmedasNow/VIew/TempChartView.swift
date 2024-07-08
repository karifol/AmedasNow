//
//  TempChartView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import Charts

struct TempChartView: View {

    var dataList:[PointItem]

    // y軸の最小値と最大値を計算
    // データの最小値-1度から最大値+1度までの範囲を返す
    var yRange: ClosedRange<Double> {
        guard let min = dataList.map(\.temp).min(),
              let max = dataList.map(\.temp).max()
        else {
            return 0...100
        }
        return (min - 1)...(max + 1)
    }

    var body: some View {
        Chart(dataList) { data in
            LineMark(
                x: .value("日時", data.date),
                y: .value("Amount", data.temp)

            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .symbol(){
                Circle()
                    .foregroundColor(.red)
                    .opacity(0)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 10, height: 10)
                    )
                    .overlay(
                        Text(String(format: "%.1f", data.temp))
                            .font(.caption)
                            .foregroundColor(.black)
                            .offset(y: -20)
                    )
            }
        }
        .chartYScale(domain: yRange)
        .chartXAxis {
            AxisMarks(values: .stride(by: .minute, count: 10)){ date in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(anchor: UnitPoint(x: 0, y: -2))
            }
        }
        .foregroundColor(.red)
        .frame(height: 200)
    }
}

#Preview {
   TempChartView(dataList: [
    PointItem(temp: 23.4, wind: 25.0, windDirection: 13, prec1h: 23.1, date: Date()),
    PointItem(temp: 24.4, wind: 25.0, windDirection: 1, prec1h: 23.1, date: Date().addingTimeInterval(60)),
    PointItem(temp: 25.0, wind: 25.0, windDirection: 0, prec1h: 23.1, date: Date().addingTimeInterval(120)),
    PointItem(temp: 26.0, wind: 25.0, windDirection: 10, prec1h: 23.1, date: Date().addingTimeInterval(180)),
    PointItem(temp: 27.4, wind: 25.0, windDirection: 4, prec1h: 23.1, date: Date().addingTimeInterval(240)),
    PointItem(temp: 25.8, wind: 25.0, windDirection: 5, prec1h: 23.1, date: Date().addingTimeInterval(300)),
    PointItem(temp: 26.4, wind: 25.0, windDirection: 8, prec1h: 23.1, date: Date().addingTimeInterval(360)),
   ])
}

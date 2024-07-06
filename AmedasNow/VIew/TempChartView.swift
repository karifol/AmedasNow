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
                    .frame(width: 10, height: 10)
            }
        }
//        .chartYScale(domain: 25 ... 30)
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
    ContentView()
}

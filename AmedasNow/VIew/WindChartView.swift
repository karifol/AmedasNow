//
//  WindChartView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import Charts

struct WindChartView: View {

    let dataList:[PointItem]

    // y軸の最小値と最大値を計算
    // データの最小値-1度から最大値+1度までの範囲を返す
    var yRange: ClosedRange<Double> {
        guard let max = dataList.map(\.wind).max()
        else {
            return 0...100
        }
        return 0...(max + 2)
    }

    var body: some View {
        Chart(dataList) { data in
            LineMark(
                x: .value("Name", data.date),
                y: .value("Amount", data.wind)

            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .symbol(){
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 10, height: 10)
            }
        }
        .chartYScale(domain: yRange)
        .foregroundColor(Color.green)
        .frame(height: 200)
    }
}

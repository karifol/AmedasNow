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
            .symbol(){
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 10)
            }
        }
//        .chartYScale(domain: 0...50)
        .foregroundColor(Color.blue)
        .frame(height: 200)
    }
}

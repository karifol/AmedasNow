//
//  TempChartView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import Charts

struct TempChartView: View {

    let dataList:[PointItem]
    
    struct SampleData: Identifiable {
        var id: String { name }
        let name: String
        let amount: Double
        let from: String
    }
//    let sampleData: [SampleData] = [
//        .init(name: "10:10", amount: 23.4, from: "PlaceA"),
//        .init(name: "10:20", amount: 23.5, from: "PlaceA"),
//        .init(name: "10:30", amount: 20, from: "PlaceA"),
//        .init(name: "10:40", amount: 31.2, from: "PlaceA"),
//        .init(name: "10:50", amount: 13.4,from: "PlaceA"),
//        .init(name: "11:00", amount: 20.3,from: "PlaceA")
//    ]

    var body: some View {
        Chart(dataList) { data in
            LineMark(
                x: .value("Name", data.date),
                y: .value("Amount", data.temp)

            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .symbol(){
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 10, height: 10)
            }
        }
        .chartYScale(domain: 25 ... 30)
        .foregroundColor(.red)
        .frame(height: 200)
    }
}

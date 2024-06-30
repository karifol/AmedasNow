//
//  Prec1hChartView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import Charts

struct Prec1hChartView: View {
    
    struct SampleData: Identifiable {
        var id: String { name }
        let name: String
        let amount: Double
        let from: String
    }
    let sampleData: [SampleData] = [
        .init(name: "10:10", amount: 23.4, from: "PlaceA"),
        .init(name: "10:20", amount: 23.5, from: "PlaceA"),
        .init(name: "10:30", amount: 20, from: "PlaceA"),
        .init(name: "10:40", amount: 31.2, from: "PlaceA"),
        .init(name: "10:50", amount: 13.4,from: "PlaceA"),
        .init(name: "11:00", amount: 20.3,from: "PlaceA")
    ]

    var body: some View {
        Chart(sampleData) { data in
            BarMark(
                x: .value("Name", data.name),
                y: .value("Amount", data.amount)

            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .symbol(){
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 10)
            }
        }
        .foregroundColor(Color.blue)
        .frame(height: 200)
    }
}

#Preview {
    Prec1hChartView()
}

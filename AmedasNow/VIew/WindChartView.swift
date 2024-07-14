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
                    .foregroundColor(.red)
                    .opacity(0)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .bold()
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(data.windDirection * 22.5 + 180))
                    )
                    .overlay(
                        Text(String(format: "%.1f", data.wind))
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
        .foregroundColor(Color.green)
        .frame(height: 200)
    }
}

#Preview {
   WindChartView(dataList: [
    PointItem(temp: 23.4, wind: 4.0, windDirection: 13, prec1h: 23.1, date: Date()),
    PointItem(temp: 24.4, wind: 2.0, windDirection: 1, prec1h: 23.1, date: Date().addingTimeInterval(60)),
    PointItem(temp: 25.0, wind: 5.0, windDirection: 0, prec1h: 23.1, date: Date().addingTimeInterval(120)),
    PointItem(temp: 26.0, wind: 8.0, windDirection: 10, prec1h: 23.1, date: Date().addingTimeInterval(180)),
    PointItem(temp: 27.4, wind: 1.0, windDirection: 4, prec1h: 23.1, date: Date().addingTimeInterval(240)),
    PointItem(temp: 25.8, wind: 3.0, windDirection: 5, prec1h: 23.1, date: Date().addingTimeInterval(300)),
    PointItem(temp: 26.4, wind: 2.0, windDirection: 8, prec1h: 23.1, date: Date().addingTimeInterval(360)),
   ])
}

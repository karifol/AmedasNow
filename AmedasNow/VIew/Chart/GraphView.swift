import SwiftUI
import MapKit

struct GraphView: View {

//    // アメダスデータ
//    var pointData = PointData()
    let dataList: [PointItem]

    @State var selectedName = "東京"

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ScrollView {
                // グラフ
                VStack(alignment: .leading) {
                    TempTitleView()
                    TempChartView(
                        dataList: dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    WindTitleView()
                    WindChartView(
                        dataList: dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    Prec1hTitleView()
                    Prec1hChartView(
                        dataList: dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

extension GraphView {

    // 気温グラフタイトル
    struct TempTitleView: View {
        var body: some View {
            HStack (spacing: 0) {
                Image(systemName: "thermometer")
                    .foregroundStyle(.red)
                Text("気温[℃]")
                    .foregroundStyle(.red)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
            }
            .padding(.horizontal, 20)
        }
    }
    // 風速グラフタイトル
    struct WindTitleView: View {
        var body: some View {
            HStack (spacing: 0) {
                Image(systemName: "wind")
                    .foregroundStyle(.green)
                Text("風速[m/s]")
                    .foregroundStyle(.green)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
            }
            .padding(.horizontal, 20)
        }
    }
    // 降水量グラフタイトル
    struct Prec1hTitleView: View {
        var body: some View {
            HStack (spacing: 0) {
                Image(systemName: "drop")
                    .foregroundStyle(.blue)
                Text("前１時間降水量[mm]")
                    .foregroundStyle(.blue)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
            }
            .padding(.horizontal, 20)
        }
    }
}

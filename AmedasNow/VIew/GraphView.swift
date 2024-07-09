//
//  GraphView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/29.
//

import SwiftUI
import MapKit

struct GraphView: View {

    // アメダスデータ
    var pointData = PointData()

    // アメダス地点データ
    var amedasTableData = AmedasTableData()
    init(){
        amedasTableData.serchAmedasTable()
        pointData.serchAmedas(
            amsid: "44132"
        )
    }

    var latestTimeData = LatestTimeData()

    @State var selectedName = "東京"

    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.711, longitude: 139.866),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    ))

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            Map(position: $cameraPosition){
                ForEach(Array(amedasTableData.amedasDict.values), id: \.id) { amedas in
                    let targetCoordinate = CLLocationCoordinate2D(latitude: amedas.lat, longitude: amedas.lon)
                    Annotation("", coordinate: targetCoordinate, anchor: .center) {
                        VStack{
                            Text(amedas.name)
                                .padding(5)
                                .foregroundStyle(amedas.type == "A" ? Color.white : Color.black)
                                .bold()
                        }
                        .background(amedas.type == "A" ? Color.pink : Color.white)
                        .border(amedas.name == selectedName ? Color.blue : Color.black, width: amedas.name == selectedName ? 4 : 2)
                        .scaleEffect(amedas.name == selectedName ? 1.5 : 1)
                        .onTapGesture {
                            selectedName = amedas.name
                            pointData.changePoint(
                                amsid: amedas.amsid
                            )
                        }
                    }

                }
            }
                .frame(height: 300)
                .padding()
                .onAppear(){
                    pointData.serchAmedas(
                        amsid: "44132"
                    )
                }

            PlaceNameView(text: selectedName)
            ScrollView {
                // グラフ
                VStack(alignment: .leading) {
                    TempTitleView()
                    TempChartView(
                        dataList: pointData.dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    WindTitleView()
                    WindChartView(
                        dataList: pointData.dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
                VStack(alignment: .leading) {
                    Prec1hTitleView()
                    Prec1hChartView(
                        dataList: pointData.dataList
                    )
                        .frame(height: 200)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

extension GraphView {

    // 地点名
    struct PlaceNameView: View {
        let text: String
        var body: some View {
            HStack{
                Spacer()
                Text(text)
                    .font(.title2)
                    .bold()
                Spacer()
            }
        }
    }
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

    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "chart.xyaxis.line")
            Text("グラフ")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
}

#Preview {
    ContentView()
}

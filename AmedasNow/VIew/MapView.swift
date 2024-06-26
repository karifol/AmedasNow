//
//  MapView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/23.
//

import SwiftUI
import MapKit

struct MapView: View {

    // アメダスデータ
    var amedasMapDataList = AmedasMapData(
        amedasTableData: AmedasTableData()
    )

    // 最新時刻
    @ObservedObject var latestTimeData = LatestTimeData()
    @State private var timeDelta: Int = 0 // 最新時刻からの差分
    @State private var basetimeDate: Date = Date()

    init(){
        latestTimeData.get()
    }

    // 要素のpicker
    @State private var selectedElement = "temp"
    private let elementList = [["風速", "wind"], ["気温", "temp"], ["降水量", "prec1h"]]

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            ZStack {
                // MapView
                MapView
                VStack(alignment: .leading){
                    // picker
                    ElementPickerView
                        .offset(y: 10)
                    Spacer()
                    // legend
                    if selectedElement == "temp" {
                        LegendTempView
                            .offset(x: 10, y: -50)
                    } else if selectedElement == "wind" {
                        LegendWindView
                            .offset(x: 10, y: -50)
                    } else if selectedElement == "prec1h" {
                        LegendPrecView
                            .offset(x: 10, y: -50)
                    }
                    // time slider
                    TimesliderView
                        .offset(y: -50)
                }
            }
        }
        .onAppear {
            latestTimeData.get()
        }
    }
}

extension MapView {

    // map
    private var MapView: some View {
        Map(){
            ForEach(amedasMapDataList.amedasList) { amedas in
                let targetCoordinate = CLLocationCoordinate2D(
                    latitude: amedas.lat,
                    longitude: amedas.lon
                )
                if (amedas.type == "A") {
                    Annotation(amedas.name, coordinate: targetCoordinate, anchor: .center) {
                        VStack {
                            Circle()
                                .fill(getCircleColor(temp: amedas.temp, prec1h: amedas.prec1h, wind: amedas.wind, element: selectedElement))
                                .frame(width: 10, height: 10)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .padding()
                        .foregroundColor(.blue)
                        .onTapGesture {
                            print(amedas.temp)
                            print(amedas.prec1h)
                            print(amedas.wind)
                        }
                    }
                }
            }
        }
    }

    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "map")
            Text("マップ")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }

    private var TimesliderView: some View {
        HStack {
            Button{
                // 10分前
                if timeDelta < 120 {
                    timeDelta += 10
                    basetimeDate = Calendar.current.date(byAdding: .minute, value: -timeDelta, to: latestTimeData.latestTime) ?? Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let basetime = formatter.string(from: basetimeDate)
                    amedasMapDataList.serchAmedas(
                        basetime: basetime
                    )
                }

            } label: {
                if timeDelta == 120 {
                    Image(systemName: "lessthan")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "lessthan")
                }
            }
            TimesliderValueView(date: latestTimeData.latestTime, delta: timeDelta)
            Button{
                // 10分後
                if timeDelta > 0 {
                    timeDelta -= 10
                    basetimeDate = Calendar.current.date(byAdding: .minute, value: -timeDelta, to: latestTimeData.latestTime) ?? Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let basetime = formatter.string(from: basetimeDate)
                    amedasMapDataList.serchAmedas(
                        basetime: basetime
                    )
                }
            } label: {
                if timeDelta == 0 {
                    Image(systemName: "greaterthan")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "greaterthan")
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding(.vertical, 10)
        .background(.black.opacity(0.5))
        .foregroundColor(.white)
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }


    // // timeslider
    struct TimesliderValueView: View {
        var date: Date
        var delta: Int
        // 差分を時間に変換
        var dateStr: String {
            let formatter = DateFormatter()
            let displayDate = Calendar.current.date(byAdding: .minute, value: -delta, to: date) ?? Date()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: displayDate)
        }
        var body: some View {
            Text(dateStr)
        }
    }

    // legend temperature
    private var LegendTempView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("気温[℃]")
                .font(.footnote)
            LegendRowView(label: "35 ~   ", color: Color.temp35)
            LegendRowView(label: "30 ~ 34", color: Color.temp30)
            LegendRowView(label: "25 ~ 29", color: Color.temp25)
            LegendRowView(label: "20 ~ 24", color: Color.temp20)
            LegendRowView(label: "15 ~ 19", color: Color.temp15)
            LegendRowView(label: "10 ~ 14", color: Color.temp10)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp5)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp0)
            LegendRowView(label: "-5 ~ -1", color: Color.temp_5)
            LegendRowView(label: "   ~ -6", color: Color.temp_10)
        }
        .padding(10)
        .background(.white)
    }

    // legend wind
    private var LegendWindView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("風速[m/s]")
                .font(.footnote)
            LegendRowView(label: "25 ~   ", color: Color.temp35)
            LegendRowView(label: "20 ~ 24", color: Color.temp30)
            LegendRowView(label: "15 ~ 19", color: Color.temp25)
            LegendRowView(label: "10 ~ 14", color: Color.temp15)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp_5)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp10)
        }
        .padding(10)
        .background(.white)
    }

    // legend prec
    private var LegendPrecView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("前1時間")
                .font(.footnote)
            Text("降水量[mm/h]")
                .font(.footnote)
            LegendRowView(label: "25 ~   ", color: Color.temp35)
            LegendRowView(label: "20 ~ 24", color: Color.temp30)
            LegendRowView(label: "15 ~ 19", color: Color.temp25)
            LegendRowView(label: "10 ~ 14", color: Color.temp15)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp_10)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp10)
        }
        .padding(10)
        .background(.white)
    }


    // legend row
    struct LegendRowView: View {
        let label: String
        let color: Color
        var body: some View {
            HStack() {
                Circle()
                    .frame(width: 10)
                    .foregroundColor(color)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                Text(label)
                    .font(.footnote)
            }
        }
    }

    // picker
    private var ElementPickerView: some View {
        Picker("Options", selection: $selectedElement) {
            ForEach(elementList, id: \.self) { row in
                Text(row[0]).tag(row[1])
            }
        }
        .background(.blue.opacity(0.5))
        .padding(.horizontal, 10)
        .pickerStyle(.palette)
    }

    // Circleの色を返す
    private func getCircleColor(temp: Double, prec1h: Double, wind: Double, element: String) -> Color {
        if element == "temp" {
            return getTempColor(temp: temp)
        } else if element == "prec1h" {
            return getPrecColor(prec1h: prec1h)
        } else if element == "wind" {
            return getWindColor(wind: wind)
        } else {
            return Color.black
        }
    }

    // 気温の色を返す
    private func getTempColor(temp: Double) -> Color {
        if temp >= 35 {
            return Color.temp35
        } else if temp >= 30 {
            return Color.temp30
        } else if temp >= 25 {
            return Color.temp25
        } else if temp >= 20 {
            return Color.temp20
        } else if temp >= 15 {
            return Color.temp15
        } else if temp >= 10 {
            return Color.temp10
        } else if temp >= 5 {
            return Color.temp5
        } else if temp >= 0 {
            return Color.temp0
        } else if temp >= -5 {
            return Color.temp_5
        } else {
            return Color.temp_10
        }
    }

    // 降水量の色を返す
    private func getPrecColor(prec1h: Double) -> Color {
        if prec1h >= 25 {
            return Color.temp35
        } else if prec1h >= 20 {
            return Color.temp30
        } else if prec1h >= 15 {
            return Color.temp25
        } else if prec1h >= 10 {
            return Color.temp20
        } else if prec1h >= 5 {
            return Color.temp15
        } else if prec1h > 0 {
            return Color.temp10
        } else {
            return Color.temp_transparent
        }
    }

    // 風速の色を返す
    private func getWindColor(wind: Double) -> Color {
        if wind >= 25 {
            return Color.temp35
        } else if wind >= 20 {
            return Color.temp30
        } else if wind >= 15 {
            return Color.temp25
        } else if wind >= 10 {
            return Color.temp15
        } else if wind >= 5 {
            return Color.temp_5
        } else if wind >= 0 {
            return Color.temp10
        } else {
            return Color.black
        }

    }
}

extension Color {
    // 気温
    static var temp35  = Color(red: 180 / 255, green: 0 / 255,   blue: 144)
    static var temp30  = Color(red: 255 / 255, green: 40 / 255,  blue: 0)
    static var temp25  = Color(red: 255 / 255, green: 153 / 255, blue: 0)
    static var temp20  = Color(red: 255 / 255, green: 245 / 255, blue: 0)
    static var temp15  = Color(red: 255 / 255, green: 255 / 255, blue: 150 / 255)
    static var temp10  = Color(red: 255 / 255, green: 255 / 255, blue: 240 / 255)
    static var temp5   = Color(red: 185 / 255, green: 235 / 255, blue: 255 / 255)
    static var temp0   = Color(red: 0,         green: 150 / 255, blue: 255 / 255)
    static var temp_5  = Color(red: 0,         green: 65 / 255,  blue: 255 / 255)
    static var temp_10 = Color(red: 0,         green: 32 / 255,  blue: 128 / 255)
    static var temp_transparent = Color(red: 0, green: 0, blue: 0, opacity: 0)
}

#Preview {
    ContentView()
}

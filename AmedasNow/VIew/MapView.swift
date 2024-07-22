import SwiftUI
import MapKit
import AppTrackingTransparency

struct MapView: View {
    
    // アメダスデータ
    var amedasMapDataList = AmedasMapData(
        amedasTableData: AmedasTableData()
    )

    // タップされた地点
    @State private var selectedAmedas: AmedasMapItem?
    // 最新時刻
    @ObservedObject var latestTimeData = LatestTimeData()
    @State private var timeDelta: Int = 0 // 最新時刻からの差分
    @State private var basetimeDate: Date = Date()


    // Mapのカメラポジション
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.711, longitude: 139.866),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    ))
    
    private func requestTrackingPermission() {
        if #available(iOS 14, *) {
            DispatchQueue.main.async {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Tracking authorized")
                    case .denied:
                        print("Tracking denied")
                    case .notDetermined:
                        print("Tracking not determined")
                    case .restricted:
                        print("Tracking restricted")
                    @unknown default:
                        print("Unknown tracking status")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            print("Tracking not available on this iOS version")
        }
    }

//    init(){
//        latestTimeData.get()
//        amedasMapDataList.serchAmedas(
//            basetime: "999"
//        )
//    }

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
                    HStack{
                        Spacer()
                        Text("タップで詳細表示")
                            .foregroundStyle(.white)
                            .bold()
                        Spacer()
                    }
                    .offset(y:-50)

                }
            }
        }
        .onAppear(){
            requestTrackingPermission()
        }
    }
}

extension MapView {
    // map
    private var MapView: some View {
        Map(position: $cameraPosition){
            ForEach(amedasMapDataList.amedasList) { amedas in
                let targetCoordinate = CLLocationCoordinate2D(
                    latitude: amedas.lat,
                    longitude: amedas.lon
                )
                Annotation(amedas.name, coordinate: targetCoordinate, anchor: .center) {
                    if selectedElement == "wind" {
                        // 矢印
                        Button(){
                            selectedAmedas = amedas
                        } label: {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 34, height: 24)
                                .bold()
                                .foregroundColor(.black)
                                .overlay(
                                    Image(systemName: "arrow.up")
                                        .resizable()
                                        .frame(width: 30, height: 20)
                                        .foregroundColor(getCircleColor(temp: amedas.temp, prec1h: amedas.prec1h, wind: amedas.wind, element: selectedElement))
                                        .offset(y: -1)
                                )
                                .rotationEffect(.degrees(amedas.windDirection * 22.5 + 180))
                        }
                    } else if selectedElement == "temp" {
                        Button(){
                            selectedAmedas = amedas
                        } label: {
                            Circle()
                                .fill(getCircleColor(temp: amedas.temp, prec1h: amedas.prec1h, wind: amedas.wind, element: selectedElement))
                                .opacity(0.5)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 1)
                                )
                        }

                    } else if selectedElement == "prec1h" {
                        Button(){
                            selectedAmedas = amedas
                        } label: {
                            Circle()
                                .fill(getCircleColor(temp: amedas.temp, prec1h: amedas.prec1h, wind: amedas.wind, element: selectedElement))
                                .frame(width: 20, height: 20)
                                .overlay(
                                    amedas.prec1h == 0 ? nil : Circle().stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }
                }
            }

        }
        .mapStyle(.imagery(elevation: .realistic))
        .sheet(item: $selectedAmedas) { item in
            SheetView(item: item)
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
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.black.opacity(0.5))
        .foregroundColor(.white)
        .font(.title)
        .onAppear(){
            latestTimeData.get()
        }
        .onChange(of: latestTimeData.latestTime){
            basetimeDate = Calendar.current.date(byAdding: .minute, value: -timeDelta, to: latestTimeData.latestTime) ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let basetime = formatter.string(from: basetimeDate)
            print(basetime)
            amedasMapDataList.serchAmedas(
                basetime: basetime
            )
        }
    }


     // timeslider
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
    
     // sheet
    struct SheetView: View {
        var item: AmedasMapItem
        var body: some View {
           VStack{
                Text(item.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding()
                HStack(spacing: 20){
                    VStack{
                        HStack{
                            Image(systemName: "thermometer")
                            Text("気温")
                        }
                            .font(.title2)
                            .foregroundColor(.red)
                        // 少数第一位まで表示
                        HStack {
                            Text(String(format: "%.1f", item.temp))
                                .font(.title2)
                            Text("℃")
                        }
                    }

                    VStack{
                        HStack{
                            Image(systemName: "wind")
                            Text("風速")
                        }
                            .font(.title2)
                            .foregroundColor(.green)
                        // 少数第一位まで表示
                        HStack {
                            Text(String(format: "%.1f", item.wind))
                                .font(.title2)
                            Text("m/s")
                        }
                    }

                    VStack{
                        HStack{
                            Image(systemName: "drop")
                            Text("降水量")
                        }
                            .font(.title2)
                            .foregroundColor(.blue)
                        // 少数第一位まで表示
                        HStack {
                            Text(String(format: "%.1f", item.prec1h))
                                .font(.title2)
                            Text("mm/h")
                        }
                    }
                }
            }
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .presentationDetents([
                .medium,
                .large,
                // 高さ
                .height(200),
                // 画面に対する割合
                .fraction(0.8)
            ])
        }
    }
}

extension Color {
    // 気温
    static var temp35  = Color(red: 180 / 255, green: 0 / 255,   blue: 14)
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
    MapView()
}

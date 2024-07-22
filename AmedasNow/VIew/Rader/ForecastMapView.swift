import SwiftUI
import MapKit

struct ForecastMapView: View {
    
    @State private var validTimeString: String = ""
    var weatherMapData = ForecastMapData()
    init(){
        weatherMapData.serchRank()
    }

    // 予想の種類
    @State private var element: String = "wm"
    // タイムスライダー
    @State private var timeSliderValue: Double = 0
    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/20240716101730/jp/20240716101730/REP/ETC/{z}/{x}/{y}.jpg")
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                MenueView // メニュー
                TimeSliderView // タイムスライダー
                if (element == "wm") {
                    LegendWeatherView // 凡例
                } else if (element == "temp") {
                    LegendTempView // 凡例
                } else if (element == "r3") {
                    LegendPrecView // 凡例
                }
            }
        }
        .onChange(of: weatherMapData.validTimeList) { oldState, newState in
            validTimeString = validTimePlus9(validTime: weatherMapData.validTimeList[0])
            let validTime = weatherMapData.validTimeList[0] // 20240713065000
            let basetime = weatherMapData.baseTime
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/\(basetime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
        }
        .onChange(of: element) { oldState, newState in
            validTimeString = validTimePlus9(validTime: weatherMapData.validTimeList[0])
            let validTime = weatherMapData.validTimeList[0] // 20240713065000
            let basetime = weatherMapData.baseTime
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/\(basetime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
        }
    }
}

extension ForecastMapView {
    
    // Map
    private var MapView: some View {
        VStack {
            KokudoMapView(overlay: overlay)
                .statusBar(hidden: false)
        }
    }
    
    // メニュー
    private var MenueView: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Button{
                        element = "wm"
                    } label: {
                        Text("天気")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(element == "wm" ? .orange: .white)
                            .background(element == "wm" ? .white: .orange)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    .padding(3)
                    Button{
                        element = "temp"
                    } label: {
                        Text("気温")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(element == "temp" ? .red: .white)
                            .background(element == "temp" ? .white: .red)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    Button{
                        element = "r3"
                    } label: {
                        Text("降水")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(element == "r3" ? .blue: .white)
                            .background(element == "r3" ? .white: .blue)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                }
                
                
            }
            .padding(.vertical)
            .background(.gray.opacity(0.01))
            .padding(.top, 50)
            Spacer()
        }
    }
    
    // タイムスライダー
    private var TimeSliderView: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    Text(validTimeString)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                    Slider(value: $timeSliderValue, in: 0...9, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            let validTime = weatherMapData.validTimeList[time] // 20240713065000
                            let basetime = weatherMapData.baseTime
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/\(basetime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            weatherMapData.serchRank()
                        }
                }
                .background(.ultraThinMaterial)
            }
            .padding()
        }
    }
    
    // 凡例
    private var LegendWeatherView: some View {
        VStack {
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.sunny)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.cloudy)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rainy)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rainySnow)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.snow)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("晴れ")
                        .frame(width: 60, height: 15)
                    Text("くもり")
                        .frame(width: 60, height: 15)
                    Text("雨")
                        .frame(width: 60, height: 15)
                    Text("雨または雪")
                        .frame(width: 60, height: 15)
                    Text("雪")
                        .frame(width: 60, height: 15)
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        // 左上に表示
        .position(x: 70, y: 200)
    }
    
    // 凡例
    private var LegendTempView: some View {
        VStack {
            Text("気温[℃]")
                .font(.footnote)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.temp35)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp30)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp25)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp20)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp15)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp10)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp0)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp_5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp_10)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp_15)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp_20)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.temp_25)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("35")
                        .frame(width: 30, height: 15)
                    Text("30")
                        .frame(width: 30, height: 15)
                    Text("25")
                        .frame(width: 30, height: 15)
                    Text("20")
                        .frame(width: 30, height: 15)
                    Text("15")
                        .frame(width: 30, height: 15)
                    Text("10")
                        .frame(width: 30, height: 15)
                    Text("5")
                        .frame(width: 30, height: 15)
                    Text("0")
                        .frame(width: 30, height: 15)
                    Text("-5")
                        .frame(width: 30, height: 15)
                    Text("-10")
                        .frame(width: 30, height: 15)
                    Text("-15")
                        .frame(width: 30, height: 15)
                    Text("-20")
                        .frame(width: 30, height: 15)
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        // 左上に表示
        .position(x: 60, y: 250)
    }
    
    // 凡例
    private var LegendPrecView: some View {
        VStack {
            Text("降水量")
                .font(.footnote)
            Text("[mm/3h]")
                .font(.footnote)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.prec20)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.prec15)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.prec10)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.prec5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.prec1)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("")
                        .frame(width: 30, height: 15)
                    Text("20")
                        .frame(width: 30, height: 15)
                    Text("15")
                        .frame(width: 30, height: 15)
                    Text("10")
                        .frame(width: 30, height: 15)
                    Text("5")
                        .frame(width: 30, height: 15)
                    Text("1")
                        .frame(width: 30, height: 15)
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        // 左上に表示
        .position(x: 60, y: 200)
    }

}

extension Color {
    static var sunny     = Color(red: 255 / 255,  green: 170 / 255, blue:   2 / 255)
    static var cloudy    = Color(red: 170 / 255,  green: 160 / 255, blue: 170 / 255)
    static var rainy     = Color(red:   6 / 255,  green:  65 / 255, blue: 255 / 255)
    static var rainySnow = Color(red: 160 / 255,  green: 210 / 255, blue: 255 / 255)
    static var snow      = Color(red: 242 / 255,  green: 242 / 255, blue: 255 / 255)
    
    static var temp_15 = Color(red: 1 / 255,   green: 23 / 255,  blue: 96 / 255)
    static var temp_20 = Color(red: 0,         green: 17 / 255,  blue: 64 / 255)
    static var temp_25 = Color(red: 0,         green:  8 / 255,  blue: 31 / 255)
    
    static var prec20 = Color(red: 255 / 255,  green: 153 / 255,  blue:   2 / 255)
    static var prec15 = Color(red: 255 / 255,  green: 245 / 255,  blue:   4 / 255)
    static var prec10 = Color(red:   6 / 255,  green:  65 / 255,  blue: 255 / 255)
    static var prec5  = Color(red:  34 / 255,  green: 140 / 255,  blue: 255 / 255)
    static var prec1  = Color(red: 160 / 255,  green: 210 / 255,  blue: 255 / 255)
}

#Preview {
    ContentView()
}

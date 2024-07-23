import SwiftUI
import MapKit

struct SeaMapView: View {
    
    @State private var validTimeString: String = ""
    var seaMapData = SeaMapData()

    // 予想の種類
    @State private var element: String = "wavh"
    @State private var validTime: String = ""
    @State private var baseTime: String = ""
    // タイムスライダー
    @State private var timeSliderValue: Double = 0
    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "")
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                VStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            Button{
                                element = "wavh"
                            } label: {
                                Text("波の高さ")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(element == "wavh" ? .blue : .white)
                                    .background(element == "wavh" ? .white : .blue)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            .padding(3)
                            Button{
                                element = "vis"
                            } label: {
                                Text("視程")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(element == "vis" ? .yellow : .white)
                                    .background(element == "vis" ? .white : .yellow)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            Button{
                                element = "wm"
                            } label: {
                                Text("天気")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(element == "wm" ? .orange : .white)
                                    .background(element == "wm" ? .white : .orange)
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
                
                if (element == "wavh") {
                    LegendWaveheightView // 凡例
                } else if (element == "vis") {
                    LegendVisView // 凡例
                } else if (element == "wm") {
                    LegendWeatherView // 凡例
                }
                TimeSliderView // タイムスライダー
            }
        }
        .onChange(of: seaMapData.validTimeList) {
            validTimeString = validTimePlus9(validTime: seaMapData.validTimeList[0])
            validTime = seaMapData.validTimeList[0] // 20240713065000
            baseTime = seaMapData.baseTime
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/umimesh/\(baseTime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
        }
        .onChange(of: element) {
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/umimesh/\(baseTime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
        }
    }
}

extension SeaMapView {
    
    // Map
    private var MapView: some View {
        VStack {
            KokudoMapView(overlay: overlay)
                .statusBar(hidden: false)
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
                    Slider(value: $timeSliderValue, in: 0...3, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            validTime = seaMapData.validTimeList[time] // 20240713065000
                            baseTime = seaMapData.baseTime
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/umimesh/\(baseTime)/none/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            seaMapData.serchRank()
                        }
                }
                .background(.ultraThinMaterial)
            }
            .padding()
        }
    }
    
    // 凡例
    private var LegendWaveheightView: some View {
        VStack {
            Text("波の高さ")
                .font(.footnote)
            Text("[m]")
                .font(.footnote)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.wavh9)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.wavh6)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.wavh4)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.wavh2_5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.wavh1_25)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("")
                        .frame(width: 30, height: 15)
                    Text("9")
                        .frame(width: 30, height: 15)
                    Text("6")
                        .frame(width: 30, height: 15)
                    Text("4")
                        .frame(width: 30, height: 15)
                    Text("2.5")
                        .frame(width: 30, height: 15)
                    Text("1.25")
                        .frame(width: 30, height: 15)
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
    private var LegendVisView: some View {
        VStack {
            Text("海里(km)")
                .font(.footnote)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.vis0_5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.vis0_3)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.vis0)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("")
                        .frame(width: 50, height: 15)
                    Text("0.5(1)")
                        .frame(width: 50, height: 15)
                    Text("0.3(0.5)")
                        .frame(width: 50, height: 15)
                    Text("")
                        .frame(width: 50, height: 15)
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .position(x: 70, y: 200)
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

}

extension Color {
    static var wavh9    = Color(red: 200 / 255,  green:   0 / 255, blue: 255 / 255)
    static var wavh6    = Color(red: 255 / 255,  green:  40 / 255, blue:   1 / 255)
    static var wavh4    = Color(red: 255 / 255,  green: 170 / 255, blue:   2 / 255)
    static var wavh2_5  = Color(red: 255 / 255,  green: 245 / 255, blue:   4 / 255)
    static var wavh1_25 = Color(red: 160 / 255,  green: 210 / 255, blue: 255 / 255)
    
    static var vis0_5  = Color(red: 217 / 255,  green: 217 / 255, blue: 255 / 255)
    static var vis0_3  = Color(red: 250 / 255,  green: 245 / 255, blue:   4 / 255)
    static var vis0    = Color(red: 255 / 255,  green: 150 / 255, blue:   2 / 255)

}

#Preview {
    ContentView()
}

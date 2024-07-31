import SwiftUI
import MapKit

struct UVView: View {

    @State private var validTimeString: String = ""
    var uvData = UVData()
    
    // 予想の種類
    @State private var element: String = "uvi_f"
    
    @State private var baseTime: String = ""
    @State private var validTime: String = ""

    // タイムスライダー
    @State private var timeSliderValue: Double = 0.0

    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "")

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                MenueView // メニュー
                TimeSliderView // タイムスライダー
                LegendView // 凡例
            }
        }
        .onChange(of: uvData.validTimeList) {
            validTimeString = validTimePlus9(validTime: uvData.validTimeList[0])
            validTime = uvData.validTimeList[0]
            baseTime = uvData.basetime
            overlay = MKTileOverlay(urlTemplate:
                                        "https://www.data.jma.go.jp/tile/uv/uv_f/\(baseTime)/\(element)/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
        }
    }
}

extension UVView {
    
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
                        element = "uvi_f"
                    } label: {
                        Text("紫外線")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(element == "uvi_f" ? .orange: .white)
                            .background(element == "uvi_f" ? .white: .orange)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    .padding(3)
                    Button{
                        element = "uvic_f"
                    } label: {
                        Text("晴天時紫外線")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(element == "uvic_f" ? .red: .white)
                            .background(element == "uvic_f" ? .white: .red)
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
                    HStack{
                        Button {
                            if timeSliderValue > 0{
                                timeSliderValue -= 1
                            }
                        } label: {
                            Image(systemName: "lessthan")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                        Text(validTimeString)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                        Spacer()
                        Button {
                            if timeSliderValue < 12{
                                timeSliderValue += 1
                            }
                        } label: {
                            Image(systemName: "greaterthan")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top)
                    .frame(width: 350)
                    Slider(value: $timeSliderValue, in: 0...12, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            baseTime = uvData.basetime
                            validTime = uvData.validTimeList[time] // 20240713065000
                            overlay = MKTileOverlay(urlTemplate: "https://www.data.jma.go.jp/tile/uv/uv_f/\(baseTime)/\(element)/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onChange(of: element) {
                            overlay = MKTileOverlay(urlTemplate: "https://www.data.jma.go.jp/tile/uv/uv_f/\(baseTime)/\(element)/\(validTime)/surf/\(element)/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            uvData.serchRank()
                        }
                }
                .background(.ultraThinMaterial)
            }
            .padding()
        }
    }
    
    // 凡例
    private var LegendView: some View {
        VStack {
            Text("UV")
                .font(.caption2)
            Text("インデックス")
                .font(.caption)
            HStack {
                ZStack{
                    VStack(spacing: 0){
                        Rectangle()
                            .foregroundColor(Color.uv13)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv12)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv11)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv10)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv9)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv8)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv7)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv6)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv5)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv4)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv3)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv2)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv1)
                            .frame(width: 25, height: 15)
                        Rectangle()
                            .foregroundColor(Color.uv0)
                            .frame(width: 25, height: 15)
                    }
                    VStack(spacing: 0){
                        Text("13+")
                            .frame(width: 20, height: 15)
                        Text("12")
                            .frame(width: 20, height: 15)
                        Text("11")
                            .frame(width: 20, height: 15)
                        Text("10")
                            .frame(width: 20, height: 15)
                        Text("9")
                            .frame(width: 20, height: 15)
                        Text("8")
                            .frame(width: 20, height: 15)
                        Text("7")
                            .frame(width: 20, height: 15)
                        Text("6")
                            .frame(width: 20, height: 15)
                        Text("5")
                            .frame(width: 20, height: 15)
                        Text("4")
                            .frame(width: 20, height: 15)
                        Text("3")
                            .frame(width: 20, height: 15)
                        Text("2")
                            .frame(width: 20, height: 15)
                        Text("1")
                            .frame(width: 20, height: 15)
                        Text("0")
                            .frame(width: 20, height: 15)
                    }
                    .font(.caption2)
                }
                VStack(spacing: 0){
                    HStack{
                        VStack(spacing: 0){
                            Text("極端に")
                            Text("強い")
                        }
                    }
                        .frame(width: 40, height: 45)
                    VStack (spacing: 0){
                        Text("非常に")
                        Text("強い")
                    }
                        .frame(width: 40, height: 45)
                    VStack (spacing: 0){
                        Text("強い")
                    }
                    .frame(width: 40, height: 30)
                    VStack (spacing: 0){
                        Text("中程度")
                    }
                    .frame(width: 40, height: 45)
                    VStack (spacing: 0){
                        Text("弱い")
                    }
                    .frame(width: 40, height: 45)
                }
                .font(.caption2)

            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .position(x: 60, y: 250)
    }
}

extension Color {
    static var uv13 = Color(red: 204 / 255, green:   0 / 255, blue: 204 / 255)
    static var uv12 = Color(red: 204 / 255, green:   0 / 255, blue: 158 / 255)
    static var uv11 = Color(red: 181 / 255, green:   1 / 255, blue:  95 / 255)
    static var uv10 = Color(red: 165 / 255, green:   1 / 255, blue:  33 / 255)
    static var uv9  = Color(red: 255 / 255, green:  17 / 255, blue:   1 / 255)
    static var uv8  = Color(red: 250 / 255, green:  87 / 255, blue:   1 / 255)
    static var uv7  = Color(red: 255 / 255, green: 157 / 255, blue:  49 / 255)
    static var uv6  = Color(red: 255 / 255, green: 199 / 255, blue:   3 / 255)
    static var uv5  = Color(red: 250 / 255, green: 245 / 255, blue:   4 / 255)
    static var uv4  = Color(red: 250 / 255, green: 250 / 255, blue: 150 / 255)
    static var uv3  = Color(red: 255 / 255, green: 255 / 255, blue: 190 / 255)
    static var uv2  = Color(red: 153 / 255, green: 203 / 255, blue: 255 / 255)
    static var uv1  = Color(red: 216 / 255, green: 216 / 255, blue: 255 / 255)
    static var uv0  = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
}

#Preview {
    ContentView()
}

import SwiftUI
import MapKit

struct ThunderNccView: View {

    var data = ThunderNccData()
    @State private var validTimeString: String = ""
    @State private var validTime: String = ""
    @State private var baseTime: String = ""
    @State private var isFcst: Bool = false

    // タイムスライダー
    @State private var timeSliderValue: Double = 0

    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "")

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                TimeSliderView // タイムスライダー
                LegendView // 凡例
            }
        }
        .onChange(of: data.validTimeList) {
            if data.validTimeList.count > 2 {
                let latestTimeIndex = data.latestTimeIndex
                validTimeString = validTimePlus9(validTime: data.validTimeList[latestTimeIndex])
                validTime = data.validTimeList[latestTimeIndex]
                baseTime = data.baseTimeList[latestTimeIndex]
                timeSliderValue = Double(latestTimeIndex)
                overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/thns/{z}/{x}/{y}.png")
            }
        }
    }
}

extension ThunderNccView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "cloud.heavyrain")
            Text("レーダー")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }

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
                            .foregroundColor(isFcst ? .red: .black)
                        Spacer()
                        Button {
                            if timeSliderValue < Double(data.validTimeList.count - 1){
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
                    Slider(value: $timeSliderValue, in: 0...Double(data.validTimeList.count - 1), step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            validTime = data.validTimeList[time]
                            baseTime = data.baseTimeList[time]
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/thns/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                            if time > data.latestTimeIndex {
                                isFcst = true
                                validTimeString += "[予測]"
                            } else {
                                isFcst = false
                            }
                        }
                        .onAppear(){
                            data.serchRank()
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
            Text("雷活動度")
                .font(.caption2)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.thn4)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.thn3)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.thn2)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.thn1)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("4")
                        .frame(width: 15, height: 15)
                    Text("3")
                        .frame(width: 15, height: 15)
                    Text("2")
                        .frame(width: 15, height: 15)
                    Text("1")
                        .frame(width: 15, height: 15)
                }
                .font(.caption2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .position(x: 50, y: 200)
    }
}

extension Color {
    static var thn4 = Color(red: 200 / 255, green:   0 / 255,  blue: 255 / 255)
    static var thn3 = Color(red: 255 / 255, green:  40 / 255,  blue:   1 / 255)
    static var thn2 = Color(red: 255 / 255, green: 170 / 255,  blue:   2 / 255)
    static var thn1 = Color(red: 255 / 255, green: 245 / 255,  blue:   4 / 255)
}

#Preview {
    ContentView()
}

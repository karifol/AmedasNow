import SwiftUI
import MapKit

struct TornadoNccView: View {

    var data = ThunderNccData()
    @State private var validTimeString: String = ""
    @State private var validTime: String = ""
    @State private var baseTime: String = ""

    // タイムスライダー
    @State private var timeSliderValue: Double = 17

    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "")

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView
                TimeSliderView
                LegendView
            }
        }
        .onChange(of: data.validTimeList) {
            if data.validTimeList.count > 2 {
                validTimeString = validTimePlus9(validTime: data.validTimeList[17])
                validTime = data.validTimeList[17]
                baseTime = data.baseTimeList[17]
                overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/trns/{z}/{x}/{y}.png")
            }
        }
    }
}

extension TornadoNccView {
    
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
                    Text(validTimeString)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.black)
                    Slider(value: $timeSliderValue, in: 0...Double(data.validTimeList.count - 1), step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            validTime = data.validTimeList[time]
                            baseTime = data.baseTimeList[time]
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/trns/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
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
            Text("竜巻発生確度")
                .font(.caption2)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.trn2)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.trn1)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
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
        // 左上に表示
        .position(x: 50, y: 200)
    }
}

extension Color {
    static var trn2 = Color(red: 255 / 255, green:  40 / 255,  blue:   1 / 255)
    static var trn1 = Color(red: 250 / 255, green: 245 / 255,  blue:   4 / 255)
}

#Preview {
    ContentView()
}

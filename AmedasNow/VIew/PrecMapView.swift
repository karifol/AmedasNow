import SwiftUI
import MapKit

struct PrecMapView: View {
    
    @State private var validTimeString: String = ""
    var weatherMapData = WeatherMapData()
    init(){
        weatherMapData.serchRank()
    }

    // タイムスライダー
    @State private var timeSliderValue: Double = 0
    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/20240718080000/none/20240718120000/surf/r3/6/56/24.png")
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                TimeSliderView // タイムスライダー
            }
        }
        .onChange(of: weatherMapData.validTimeList) { oldState, newState in
            // 最後の値を取る
            validTimeString = validTimePlus9(validTime: weatherMapData.validTimeList[ weatherMapData.validTimeList.count - 1])
            let validTime = weatherMapData.validTimeList[0] // 20240713065000
            let basetime = weatherMapData.baseTime
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/\(basetime)/none/\(validTime)/surf/r3/{z}/{x}/{y}.png")
        }
    }
}

extension PrecMapView {
    
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
                    Slider(value: $timeSliderValue, in: 0...9, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = 10 - Int(newState)
                            let validTime = weatherMapData.validTimeList[time] // 20240713065000
                            let basetime = weatherMapData.baseTime
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/wdist/\(basetime)/none/\(validTime)/surf/r3/{z}/{x}/{y}.png")
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

}

#Preview {
    ContentView()
}

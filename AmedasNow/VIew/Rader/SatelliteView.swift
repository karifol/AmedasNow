import SwiftUI
import MapKit

struct SatelliteView: View {
    
    @State private var validTimeString: String = ""
    var satelliteData = SatelliteData()
    init(){
        satelliteData.serchRank()
    }
    
    // 衛星の種類
    @State private var element: String = "SND/ETC"

    // タイムスライダー
    @State private var timeSliderValue: Double = 863
    
    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/20240716101730/jp/20240716101730/REP/ETC/{z}/{x}/{y}.jpg")
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                VStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            Button{
                                element = "B03/ALBD"
                            } label: {
                                Text("可視")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(.yellow)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            .padding(3)
                            Button{
                                element = "B13/TBB"
                            } label: {
                                Text("赤外")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            Button{
                                element = "B08/TBB"
                            } label: {
                                Text("水蒸気")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            Button{
                                element = "REP/ETC"
                            } label: {
                                Text("トゥルーカラー")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(.green)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            Button{
                                element = "SND/ETC"
                            } label: {
                                Text("雲頂強調")
                                    .padding(5)
                                    .padding(.horizontal)
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(.orange)
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
                TimeSliderView // タイムスライダー
            }

        }
        .onChange(of: satelliteData.validTimeList) { oldState, newState in
            validTimeString = validTimePlus9(validTime: satelliteData.validTimeList[0])
            let validTime = satelliteData.validTimeList[0] // 20240713065000
            print(validTime)
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/\(validTime)/jp/\(validTime)/\(element)/{z}/{x}/{y}.jpg")
        }
        .onChange(of: element){ oldState, newState in
            validTimeString = validTimePlus9(validTime: satelliteData.validTimeList[0])
            let validTime = satelliteData.validTimeList[0] // 20240713065000
            print(validTime)
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/\(validTime)/jp/\(validTime)/\(element)/{z}/{x}/{y}.jpg")
        }
    }
}

extension SatelliteView {
    
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
                    Slider(value: $timeSliderValue, in: 0...863, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = 863 - Int(newState)
                            let validTime = satelliteData.validTimeList[time] // 20240713065000
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/\(validTime)/jp/\(validTime)/\(element)/{z}/{x}/{y}.jpg")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            satelliteData.serchRank()
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
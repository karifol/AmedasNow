import SwiftUI
import MapKit

struct PrecNccView: View {
   
    var data = PrecNccData()
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
                overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/hrpns/{z}/{x}/{y}.png")
            }
        }
    }
}

extension PrecNccView {
    
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
                            if timeSliderValue < 48{
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

                    Slider(value: $timeSliderValue, in: 0...48, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = Int(newState)
                            validTime = data.validTimeList[time] // 20240713065000
                            baseTime = data.baseTimeList[time]
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(baseTime)/none/\(validTime)/surf/hrpns/{z}/{x}/{y}.png")
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
            Text("mm/h")
                .font(.caption2)
            HStack {
                VStack(spacing: 0){
                    Rectangle()
                        .foregroundColor(Color.rader80)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader50)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader30)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader20)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader10)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader5)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader1)
                        .frame(width: 15, height: 15)
                    Rectangle()
                        .foregroundColor(Color.rader0)
                        .frame(width: 15, height: 15)
                }
                VStack(spacing: 0){
                    Text("80")
                        .frame(width: 15, height: 15)
                    Text("50")
                        .frame(width: 15, height: 15)
                    Text("30")
                        .frame(width: 15, height: 15)
                    Text("20")
                        .frame(width: 15, height: 15)
                    Text("10")
                        .frame(width: 15, height: 15)
                    Text("5")
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
    static var rader80 = Color(red: 200 / 255, green: 73 / 255,  blue: 145 / 255)
    static var rader50 = Color(red: 255 / 255, green: 101 / 255, blue: 73 / 255)
    static var rader30 = Color(red: 255 / 255, green: 179 / 255, blue: 73 / 255)
    static var rader20 = Color(red: 255 / 255, green: 247 / 255, blue: 74 / 255)
    static var rader10 = Color(red:  74 / 255, green: 118 / 255, blue: 255 / 255)
    static var rader5  = Color(red:  97 / 255, green: 171 / 255, blue: 255 / 255)
    static var rader1  = Color(red: 185 / 255, green: 222 / 255, blue: 255 / 255)
    static var rader0  = Color(red: 246 / 255, green: 245 / 255, blue: 255 / 255)
}

#Preview {
    ContentView()
}

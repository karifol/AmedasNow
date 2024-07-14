import SwiftUI
import MapKit

struct RaderView: View {

    @State private var validTimeString: String = ""
    var raderData = RaderData()
    init(){
        raderData.serchRank()
    }

    // タイムスライダー
    @State private var timeSliderValue: Double = 36.0

    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/20240713064500/none/20240713064500/surf/hrpns/{z}/{x}/{y}.png")

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView // ヘッダー
            ZStack {
                MapView // Map
                TimeSliderView // タイムスライダー
                LegendView // 凡例
            }
        }
        .onChange(of: raderData.validTimeList) { oldState, newState in
            validTimeString = validTimePlus9(validTime: raderData.validTimeList[0])
            let validTime = raderData.validTimeList[0] // 20240713065000
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(validTime)/none/\(validTime)/surf/hrpns/{z}/{x}/{y}.png")
            validTimeString = validTimePlus9(validTime: validTime)
        }
    }
}

struct KokudoMapView: UIViewRepresentable {
    var overlay: MKTileOverlay

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: KokudoMapView

        init(_ parent: KokudoMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        return MKMapView()
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.delegate = context.coordinator

        let overlays = mapView.overlays
        mapView.addOverlay(overlay)
        for overlay in overlays {
            if overlay is MKTileOverlay {
                mapView.removeOverlay(overlay)
            }
        }
        // realistic
        mapView.mapType = .hybrid
    }
}

extension RaderView {
    
    // 20240713065000に9時間足す関数
    func validTimePlus9(validTime: String) -> String {
        let year = validTime.prefix(4)
        let month = validTime.prefix(6).suffix(2)
        let day = validTime.prefix(8).suffix(2)
        let hour = validTime.prefix(10).suffix(2)
        let minute = validTime.prefix(12).suffix(2)
        let validCalender = Calendar.current.date(from: DateComponents(year: Int(year)!, month: Int(month)!, day: Int(day)!, hour: Int(hour)!, minute: Int(minute)!, second: 0))!
        let validTimePlus9 = validCalender.addingTimeInterval(60*60*18)
        let validTimePlus9String = validTimePlus9.description
        let hour9 = validTimePlus9String.prefix(13).suffix(2)
        let minute9 = validTimePlus9String.prefix(16).suffix(2)
        return "\(hour9)時\(minute9)分"
    }
    
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
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                    Slider(value: $timeSliderValue, in: 0...36, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = 36 - Int(newState)
                            let validTime = raderData.validTimeList[time] // 20240713065000
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/jmatile/data/nowc/\(validTime)/none/\(validTime)/surf/hrpns/{z}/{x}/{y}.png")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            raderData.serchRank()
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
        // 左上に表示
        .position(x: 50, y: 100)
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

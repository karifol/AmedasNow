import SwiftUI
import MapKit

struct MultiMapView: View {
    
    @State private var selectedItem: Int = 0
    
    var body: some View {
        VStack (spacing: 0){
            HeaderView

            ZStack {
                switch selectedItem {
                case 0:
                    RainCloudView()
                case 1:
                    SatelliteView()
                case 2:
                    ForecastMapView()
                case 3:
                    SeaMapView()
                case 4:
                    UVView()
                case 5:
                    PrecAnalisysView()
                default:
                    SatelliteView()
                }

                VStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            Button {
                                selectedItem = 0
                            } label: {
                                HStack {
                                    Image(systemName: "cloud.heavyrain")
                                    Text("雨雲の動き")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 0 ? .blue : .white)
                                .background(selectedItem == 0 ? .white : .blue)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                            Button {
                                selectedItem = 5
                            } label: {
                                HStack {
                                    Image(systemName: "cloud.heavyrain.fill")
                                    Text("解析雨量")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 5 ? .precAnalysis : .white)
                                .background(selectedItem == 5 ? .white : .precAnalysis)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                            Button {
                                selectedItem = 1
                            } label: {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("衛星画像")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 1 ? .green : .white)
                                .background(selectedItem == 1 ? .white : .green)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                            Button {
                                selectedItem = 2
                            } label: {
                                HStack {
                                    Image(systemName: "sun.max.fill")
                                    Text("天気予想")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 2 ? .orange : .white)
                                .background(selectedItem == 2 ? .white : .orange)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                            Button {
                                selectedItem = 3
                            } label: {
                                HStack {
                                    Image(systemName: "water.waves")
                                    Text("海上予想")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 3 ? .blue : .white)
                                .background(selectedItem == 3 ? .white : .blue)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                            Button {
                                selectedItem = 4
                            } label: {
                                HStack {
                                    Image(systemName: "headlight.low.beam.fill")
                                    Text("紫外線予想")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(selectedItem == 4 ? .red : .white)
                                .background(selectedItem == 4 ? .white : .red)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white, lineWidth: 2)
                                )
                            }
                            .padding(3)
                        }
                    }
                    .padding(.vertical)
                    .background(.gray.opacity(0.01))
                    Spacer()
                }
            }
        }
    }
}

// レーダー共通
class CustomTileOverlayRenderer: MKTileOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        context.setAlpha(0.7)
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}

struct KokudoMapView: UIViewRepresentable {
    var overlay: MKTileOverlay

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addOverlay(overlay)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(overlay)
        // hybrid
        mapView.mapType = .hybrid
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: KokudoMapView

        init(_ parent: KokudoMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKTileOverlay {
                let renderer = CustomTileOverlayRenderer(overlay: overlay as! MKTileOverlay)
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

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
    let day9 = validTimePlus9String.prefix(10).suffix(2)
    let hour9 = validTimePlus9String.prefix(13).suffix(2)
    let minute9 = validTimePlus9String.prefix(16).suffix(2)
    return "\(day9)日\(hour9)時\(minute9)分"
}

extension MultiMapView {
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
}

extension Color {
    static var precAnalysis = Color(red: 1 / 255, green:   1 / 255,  blue: 255 / 255)
}

#Preview {
    MultiMapView()
}

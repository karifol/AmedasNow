import SwiftUI
import MapKit

struct MultiMapView: View {
    
    @State private var selectedItem: Int = 0
    
    var body: some View {
        VStack (spacing: 0){
            HeaderView
            ZStack {
                // 選択されたMap
                if selectedItem == 0 {
                    RaderView()
                } else if selectedItem == 1 {
                    SatelliteView()
                } else if selectedItem == 2 {
                    SatelliteView()
                } else {
                    SatelliteView()
                }

                VStack {
                    ScrollView(.horizontal){
                        HStack{
                            Button {
                                selectedItem = 0
                            } label: {
                                HStack {
                                    Image(systemName: "cloud.heavyrain")
                                    Text("雨雲レーダー")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(.white)
                                .background(.blue)
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
                                    Text("衛星")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(.white)
                                .background(.green)
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
                                    Image(systemName: "sun.horizon.fill")
                                    Text("天気分布予想")
                                }
                                .padding(5)
                                .bold()
                                .foregroundColor(.white)
                                .background(.orange)
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
struct KokudoMapView: UIViewRepresentable {
    var overlay: MKTileOverlay
    var maxZoom: Int = 100

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

#Preview {
    MultiMapView()
}
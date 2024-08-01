import SwiftUI
import MapKit

struct ForecastJapanView: View {
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.711, longitude: 139.866),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    ))
    var body: some View {
        Map(position: $cameraPosition){
            let targetCoordinate = CLLocationCoordinate2D(
                latitude: 36.69,
                longitude: 138.93
            )
            Annotation("Annotation", coordinate: targetCoordinate, anchor: .center) {
                    Text("test")
                    .background(.red)
                    .frame(width: 300, height: 200)
            }
        }
    }
}

#Preview {
    ForecastJapanView()
}

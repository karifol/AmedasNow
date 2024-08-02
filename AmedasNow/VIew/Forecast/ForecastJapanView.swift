import SwiftUI
import MapKit

struct ForecastJapanView: View {
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35, longitude: 137),
        span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
    ))
    var body: some View {
        VStack(spacing: 0){
            HeaderView
            Map(position: $cameraPosition){
                let targetCoordinate = CLLocationCoordinate2D(
                    latitude: 36.69,
                    longitude: 138.93
                )
                Annotation("東京", coordinate: targetCoordinate, anchor: .center) {
                    Button{
                    
                    } label: {
                        Image("101")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .mapStyle(.imagery(elevation: .realistic))
        }

    }
}

extension ForecastJapanView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "cloud.sun.rain")
            Text("天気予報")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
}

#Preview {
    ForecastJapanView()
}

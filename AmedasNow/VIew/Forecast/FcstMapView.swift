import SwiftUI
import MapKit

struct FcstMapView: View {

    let fmpd = FcstMapPlaceData()
    let fmfd = FcstMapFcstData()
    
    @State private var validDate = ""
    
    @State private var selectedId = ""
    @State private var selectedName = ""
    @State private var displaySheet = false
    
    @State private var fmfd_class10_wxDict = [:]
    @State private var fmfd_office_wxDict = [:]

    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36, longitude: 139.5),
        span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
    ))

    var body: some View {
        VStack(spacing: 0){
            HeaderView
            ZStack {
                VStack{
                    Text("タップで詳細表示")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .bold()
                        .padding(10)
                        .background(.black.opacity(0.5))
                        .padding(.top, 10)
                    Spacer()
                    VStack {
                        ScrollView(.horizontal){
                            HStack(alignment: .center){
                                ForEach(0..<fmfd.all_vtList.count, id: \.self) { i in
                                        Button {
                                            validDate = fmfd.all_vtList[i]
                                        } label: {
                                            Text(fmfd.all_vtList[i].prefix(10))
                                                .padding(10)
                                                .font(.title2)
                                                .bold()
                                                .background(validDate == fmfd.all_vtList[i] ? .blue : .white)
                                                .foregroundColor(validDate == fmfd.all_vtList[i] ? .white : .blue)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                        }
                        .padding(10)
                    }
                    .background(.black.opacity(0.5))
                    .padding(.bottom, 50)
                }
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                MapView
            }
        }
        .onAppear(){
            fmpd.serchAsync()
            fmfd.serchAsync()
        }
        .onChange(of: fmfd.all_vtList){
            fmfd_class10_wxDict = fmfd.class10_wxDict
            fmfd_office_wxDict = fmfd.office_wxDict
            validDate = fmfd.all_vtList[0]
        }
    }
}

extension FcstMapView {
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
    
    // map
    private var MapView: some View {
        Map(position: $cameraPosition){
            ForEach(0..<fmpd.idList.count, id: \.self) { i in
                if (fmfd_class10_wxDict[fmpd.idList[i]] != nil) {
                    if ((fmfd.class10_wxDict[fmpd.idList[i]]![validDate]) != nil){
                        let targetCoordinate = CLLocationCoordinate2D(
                            latitude: fmpd.lonList[i],
                            longitude: fmpd.latList[i]
                        )
                        Annotation(fmpd.nameList[i], coordinate: targetCoordinate, anchor: .center) {
                            Button{
                                selectedId = fmpd.prefList[i]
                                selectedName = fmpd.nameList[i]
                                if selectedId == fmpd.prefList[i] {
                                    displaySheet = true
                                }
                            } label: {
                                Image(fmfd.class10_wxDict[fmpd.idList[i]]![validDate] ?? "")
                                    .resizable()
                                    .frame(width: 50, height: 40)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
            }
            ForEach(0..<fmpd.idList.count, id: \.self) { i in
                if (fmfd_office_wxDict[fmpd.idList[i]] != nil) {
                    if ((fmfd.office_wxDict[fmpd.idList[i]]![validDate]) != nil){
                        let targetCoordinate = CLLocationCoordinate2D(
                            latitude: fmpd.lonList[i],
                            longitude: fmpd.latList[i]
                        )
                        Annotation(fmpd.nameList[i], coordinate: targetCoordinate, anchor: .center) {
                            Button{
                                selectedId = fmpd.prefList[i]
                                selectedName = fmpd.nameList[i]
                                if selectedId == fmpd.prefList[i] {
                                    displaySheet = true
                                }
                            } label: {
                                Image(fmfd.office_wxDict[fmpd.idList[i]]![validDate] ?? "")
                                    .resizable()
                                    .frame(width: 50, height: 40)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
            }
        }
        .mapStyle(.imagery(elevation: .realistic))
        .onChange(of: selectedId){
            displaySheet = true
        }
        .sheet(isPresented: $displaySheet){
            ForecastPrefView(id: selectedId, prefName: String(selectedName.split(separator: " ")[0]))
        }
    }
}

#Preview {
    FcstMapView()
}

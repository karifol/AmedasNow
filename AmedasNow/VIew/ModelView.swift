import SwiftUI
import MapKit

struct ModelView: View {

    @State var selected: String = "ecmwf_ifs025"
    @State var name: String = ""
    @State var lat: Double = 0
    @State var lon: Double = 0
    @State var isSheet: Bool = false
    @State var nameList: [String] = [""]
    @State var latList: [Double] = []
    @State var lonList: [Double] = []
    @State var timeList: [String] = [""]
    @State var hourList: [String] = [""]
    @State var tempList: [String] = [""]
    @State var precList: [String] = [""]
    
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.711, longitude: 139.866),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    ))
    
    var md = ModelData()
    var ald = AmedasListData()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView
            Map(position: $cameraPosition){
                ForEach(nameList.indices, id: \.self){ i in
                    if i < latList.count && i < lonList.count {
                        let targetCoordinate = CLLocationCoordinate2D(
                            latitude: latList[i],
                            longitude: lonList[i]
                        )
                        Annotation(nameList[i], coordinate: targetCoordinate, anchor: .center) {
                            Button{
                                name = nameList[i]
                                lat = latList[i]
                                lon = lonList[i]
                                isSheet = true
                            } label: {
                                Circle()
                            }
                        }
                    }
                }
            }
        } 
        .sheet(isPresented: $isSheet){
            VStack{
                Text(name)
                    .font(.title)
                    .bold()
                ModelmenueView
                TableView
            }
            .padding()
        }
        .onAppear(){
            md.serch(model:selected)
            ald.serchAmedasTable()
        }
        .onChange(of: md.timeList){
            timeList = md.timeList
            hourList = md.hourList
            tempList = md.tempList
            precList = md.precList
        }
        .onChange(of: ald.nameList){
            nameList = ald.nameList
            latList = ald.latList
            lonList = ald.lonList
        }
        .onChange(of: selected){
            md.serch(model:selected)
        }
    }
}

extension ModelView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "tropicalstorm")
            Text("気象モデル")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
    
    // model menue
    private var ModelmenueView: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center, spacing: 10){
                    Button{
                        selected = "ecmwf_ifs025"
                    } label: {
                        HStack{
                            Image("ecmwf")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("ECMWF")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .background(selected == "ecmwf_ifs025" ? .clear : Color.gray.opacity(0.5))
                        .border(selected == "ecmwf_ifs025" ? .blue: .clear)
                    }
                    Button{
                        selected = "gfs_seamless"
                    } label: {
                        HStack{
                            Image("noaa")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("GFS")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .background(selected == "gfs_seamless" ? .clear : Color.gray.opacity(0.5))
                        .border(selected == "gfs_seamless" ? .blue: .clear)
                    }
                    Button{
                        selected = "jma_seamless"
                    } label: {
                        HStack{
                            Image("jma")
                                .resizable()
                                .frame(width: 70, height: 30)
                            Text("GSM")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .background(selected == "jma_seamless" ? .clear : Color.gray.opacity(0.5))
                        .border(selected == "jma_seamless" ? .blue: .clear)
                    }
                }
            }
        }
        .padding()
    }
    
    // model menue
    private var TableView: some View {
        VStack{
            HStack(spacing: 0){
                VStack{
                    Text("月日")
                }
                .frame(width: 70)
                VStack{
                    Text("時間")
                }
                .frame(width: 70)
                VStack{
                    Text("気温(℃)")
                }
                .frame(width: 70)
                VStack{
                    Text("降水量(mm/h)")
                }
                .frame(width: 150)
            }
            .background(.blue)
            .foregroundColor(.white)
            .bold()
            .padding(0)
            ScrollView{
                VStack(spacing:0){
                    ForEach(timeList.indices, id: \.self){ i in
                        HStack(spacing: 0){
                            VStack{
                                Text(timeList[i])
                            }
                            .frame(width: 70)
                            VStack{
                                Text(hourList[i])
                            }
                            .frame(width: 70)
                            VStack{
                                Text(tempList[i])
                            }
                            .frame(width: 70)
                            VStack{
                                Text(precList[i])
                            }
                            .frame(width: 150)
                        }
                        Divider()
                            .frame(width: 360)
                            .padding(1)
                    }
                }
            }
            .padding(0)
        }
    }
}

#Preview {
    ModelView()
}

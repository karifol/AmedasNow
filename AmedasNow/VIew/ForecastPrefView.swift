import SwiftUI

struct ForecastPrefView: View {
    let id: String
    let prefName: String
    let fpd = ForecastPointData()
    var body: some View {
        VStack {
            HeaderView
            ScrollView{
                Text(prefName)
                    .font(.title)
                    .bold()
                
                // srf
                VStack{
                    HStack {
                        Text("明後日までの詳細")
                            .font(.title2)
                        Spacer()
                    }
                    ForEach(0..<fpd.srf_areaName.count, id: \.self) { idx in
                        HStack {
                            Text(fpd.srf_areaName[idx])
                                .font(.title2)
                            Spacer()
                        }
                        HStack {
                            ForEach(0..<fpd.srf_wx_timeDifines.count, id: \.self) { idx2 in
                                Text(fpd.srf_wx_timeDifines[idx2])
                            }
                            Spacer()
                        }
                        HStack {
                            ForEach(0..<fpd.srf_wxCode[idx].count, id: \.self) { idx2 in                            Text(fpd.srf_wxCode[idx][idx2])
                            }
                            Spacer()
                        }

                        Divider()
                    }
                }
                .padding()

            }
        }
        .onAppear(){
            fpd.serch(id: id)
        }
    }
}

extension ForecastPrefView {
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
    ForecastPrefView(id: "1000000", prefName: "東京")
}

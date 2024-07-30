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
                            VStack {
                                Text("日時")
                                    .frame(height: 10)
                                    .font(.caption)
                                Divider()
                                Text("天気")
                                    .frame(height: 50)
                                    .font(.caption)
                                Divider()
                                Text("概況")
                                    .frame(height: 40)
                                    .font(.caption)
                                Divider()
                                Text("風")
                                    .frame(height: 10)
                                    .font(.caption)
                                Divider()
                                Text("最高")
                                    .frame(height: 10)
                                    .font(.caption)
                                Text("最低")
                                    .frame(height: 10)
                                    .font(.caption)
                            }
                            .frame(width: 30)
                            .padding(.vertical, 10)
                            .background(.gray.opacity(0.1))
                            .foregroundColor(.black)
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(0..<fpd.srf_wx_timeDifines.count, id: \.self) { idx2 in
                                        VStack {
                                            Text(fpd.srf_wx_timeDifines[idx2])
                                                .frame(height: 10)
                                            Divider()
                                            Image("101")
                                                .resizable()
                                                .frame(width: 60, height: 50)
                                            Divider()
                                            Text(fpd.srf_wxName[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]] ?? "")
                                                .font(.caption)
                                                .frame(height: 40)
                                            Divider()
                                            Text(fpd.srf_wxWind[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]] ?? "")
                                                .font(.caption)
                                                .frame(height: 10)
                                            Divider()
                                            HStack {
                                                Text(fpd.srf_tmpTemp[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]]?["max"] ?? "")
                                                    .font(.caption)
                                                    .frame(height: 10)
                                                    .foregroundStyle(.red)
                                                Text("℃")
                                                    .font(.caption)
                                                    .frame(height: 10)
                                                    .foregroundStyle(.red)
                                            }
                                            HStack {
                                                Text(fpd.srf_tmpTemp[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]]?["min"] ?? "")
                                                    .font(.caption)
                                                    .frame(height: 10)
                                                    .foregroundStyle(.blue)
                                                Text("℃")
                                                    .font(.caption)
                                                    .frame(height: 10)
                                                    .foregroundStyle(.blue)
                                            }

                                        }
                                        .padding(10)
                                        .frame(width: 200)
                                        Divider()
                                    }
                                }
                            }
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

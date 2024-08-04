import SwiftUI

struct ForecastPrefView: View {
    let id: String
    let prefName: String
    let fpd = ForecastPointData()
    let fod = ForecastOverviewData()
    var body: some View {
        VStack {
            ScrollView{
                // title
                TitleView
                
                // srf
                SrfView
                
                // overview
                OverviewView
                
                // mrf
                MrfView
            }
        }
        .background(.gray.opacity(0.1))
        .onAppear(){
            fpd.serch(id: id)
            fod.serch(id: id)
        }
    }
}

extension ForecastPrefView {
    // title
    private var TitleView: some View {
        Text(prefName)
            .font(.title)
            .bold()
            .padding(.top)
    }
    
    // srf
    private var SrfView: some View {
        VStack{
            HStack {
                Text("明後日までの詳細")
                    .font(.title2)
                Spacer()
            }
            Divider()
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
                            .frame(height: 80)
                            .font(.caption)
                        Divider()
                        Text("風")
                            .frame(height: 10)
                            .font(.caption)
                        Divider()
                        Text("最高気温")
                            .frame(height: 10)
                            .font(.caption)
                        Text("最低気温")
                            .frame(height: 10)
                            .font(.caption)
                    }
                    .frame(width: 60)
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
                                    Image(fpd.srf_wxCode[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]] ?? "")
                                        .resizable()
                                        .frame(width: 60, height: 50)
                                    Divider()
                                    Text(fpd.srf_wxName[fpd.srf_areaName[idx]]?[fpd.srf_wx_timeDifines[idx2]] ?? "")
                                        .font(.caption)
                                        .frame(height: 80)
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
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
    
    // mrf
    private var MrfView: some View {
        VStack{
            HStack {
                Text("7日先まで")
                    .font(.title2)
                Spacer()
            }
            Divider()
            ForEach(0..<fpd.mrf_areaName.count, id: \.self) { idx in
                HStack {
                    Text(fpd.mrf_areaName[idx])
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
                        Text("降水確率")
                            .frame(height: 10)
                            .font(.caption)
                        Divider()
                        Text("信頼度")
                            .frame(height: 10)
                            .font(.caption)
                        Divider()
                        Text("最高気温")
                            .frame(height: 10)
                            .font(.caption)
                        Divider()
                        Text("最低気温")
                            .frame(height: 10)
                            .font(.caption)
                    }
                    .frame(width: 60)
                    .padding(.vertical, 10)
                    .background(.gray.opacity(0.1))
                    .foregroundColor(.black)
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(0..<fpd.mrf_wx_timeDifines.count, id: \.self) { idx2 in
                                VStack {
                                    Text(fpd.mrf_wx_timeDifines[idx2])
                                        .frame(height: 10)
                                    Divider()
                                    Image(fpd.mrf_wxCode[fpd.mrf_areaName[idx]]?[fpd.mrf_wx_timeDifines[idx2]] ?? "-")
                                        .resizable()
                                        .frame(width: 60, height: 50)
                                    Divider()
                                    Text(fpd.mrf_wxPop[fpd.mrf_areaName[idx]]?[fpd.mrf_wx_timeDifines[idx2]] ?? "-")
                                        .font(.caption)
                                        .frame(height: 10)
                                    Divider()
                                    Text(fpd.mrf_wxReliability[fpd.mrf_areaName[idx]]?[fpd.mrf_wx_timeDifines[idx2]] ?? "-")
                                        .font(.caption)
                                        .frame(height: 10)
                                    Divider()
                                    Text(fpd.mrf_tmpMax[fpd.mrf_areaName[idx]]?[fpd.mrf_wx_timeDifines[idx2]] ?? "-")
                                        .font(.caption)
                                        .frame(height: 10)
                                        .foregroundStyle(.red)
                                    Divider()
                                    Text(fpd.mrf_tmpMin[fpd.mrf_areaName[idx]]?[fpd.mrf_wx_timeDifines[idx2]] ?? "-")
                                        .font(.caption)
                                        .frame(height: 10)
                                        .foregroundStyle(.blue)
                                }
                                .padding(10)
                                .frame(width: 100)
                                Divider()
                            }
                        }
                    }
                }
                Divider()
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
    
    // overview
    private var OverviewView: some View {
        VStack {
            HStack {
                Text("概況")
                    .font(.title2)
                Spacer()
            }
            Divider()
            ScrollView(.horizontal) {
                Text(fod.overview)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    ForecastPrefView(id: "100000", prefName: "東京")
}

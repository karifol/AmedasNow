import SwiftUI

struct MenueView: View {
    
    @State var selected:Int = 0
    
    var body: some View {
        VStack (alignment: .center, spacing: 0){
            if (selected == 0) {
                MenueContentView
            } else if (selected == 1){
                WeatherMapView()
            } else if (selected == 2){
                ForecastView()
            } else if (selected == 3){
                RankView()
            }
        }
        .background(.white)
        .onAppear(){
            selected = 0
        }
    }
}

extension MenueView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "menucard")
            Text("メニュー")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
    
    private var MenueContentView: some View {
        VStack{
            HeaderView
            ScrollView{
                Text("メニュー")
                    .font(.title2)
                    .padding(.top)
                Divider()
                    .padding(10)
                Button {
                    selected = 1
                } label: {
                    HStack {
                        Image(systemName: "photo")
                        Text("天気図")
                    }
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
                    .frame(width: 300, height: 30)
                    .padding(.vertical, 10)
                    .background(.green)
                }
                .padding(3)
                Button {
                    selected = 2
                } label: {
                    HStack {
                        Image(systemName: "cloud.sun.rain")
                        Text("天気予報")
                    }
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
                    .frame(width: 300, height: 30)
                    .padding(.vertical, 10)
                    .background(.orange)
                }
                .padding(3)
                Button {
                    selected = 3
                } label: {
                    HStack {
                        Image(systemName: "list.number")
                        Text("AMeDASランキング")
                    }
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
                    .frame(width: 300, height: 30)
                    .padding(.vertical, 10)
                    .background(.blue)
                }
                .padding(3)
                SourceView
            }

        }
    }
    
    // 出典
    private var SourceView: some View {
        VStack (alignment: .center, spacing: 5){
            Text("出典")
                .font(.title2)
            Divider()
                .padding(5)
            HStack {
                Spacer()
                Link("出典 : 天気図 | 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/weather_map/")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 気象衛星ひまわり | 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/map.html#5/34.5/137/&elem=vis&contents=himawari")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 海上分布予報 | 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/umimesh/#lat:37.002553/lon:138.999023/zoom:5/colordepth:deep/elements:weather")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 天気分布予報 | 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/wdist/#lat:35.550105/lon:138.999023/zoom:5/colordepth:deep/elements:wm")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 雨雲の動き| 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/nowc/#lat:32.856518/lon:135.461426/zoom:7/colordepth:normal/elements:hrpns&slmcs&slmcs_fcst")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 紫外線情報（分布図）| 気象庁", destination: URL(string: "https://www.data.jma.go.jp/gmd/env/uvindex/index.html")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : AMeDAS | 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/amedas/")!)
                Spacer()
            }
            HStack {
                Spacer()
                Link("出典 : 毎日の全国観測値ランキング | 気象庁", destination: URL(string: "https://www.data.jma.go.jp/obd/stats/data/mdrr/rank_daily/index.html")!)
                Spacer()
            }
        }

    }
}

#Preview {
    MenueView()
}

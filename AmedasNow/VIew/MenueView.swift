import SwiftUI

struct MenueView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            Spacer()
            HStack {
                Spacer()
                Link("出典 : 雨雲の動き| 気象庁", destination: URL(string: "https://www.jma.go.jp/bosai/nowc/#lat:32.856518/lon:135.461426/zoom:7/colordepth:normal/elements:hrpns&slmcs&slmcs_fcst")!)
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
            Spacer()
        }
        .background(.white)
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
}

#Preview {
    MenueView()
}

import SwiftUI
import AppTrackingTransparency

struct ContentView: View {

    @State var selection: Int = 2

    var body: some View {
        TabView(selection: $selection) {
            MenueView()
                .tabItem {
                    Image(systemName: "menucard")
                    Text("メニュー")
                }
                .tag(0)
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("マップ")
                }
                .tag(1)
            RaderView()
                .tabItem {
                    Image(systemName: "cloud.heavyrain")
                    Text("レーダー")
                }
                .tag(2)
            RankView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("ランキング")
                }
                .tag(3)
            GraphView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("グラフ")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}

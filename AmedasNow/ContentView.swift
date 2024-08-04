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
                    Text("アメダス")
                }
                .tag(1)
            MultiMapView()
                .tabItem {
                    Image(systemName: "cloud.heavyrain")
                    Text("レーダー")
                }
                .tag(2)
            FcstMapView()
                .tabItem {
                    Image(systemName: "cloud.sun.fill")
                    Text("天気予報")
                }
                .tag(3)
            RankView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("ランキング")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {

    @State var selection: Int = 2
    @AppStorage("is_init") var isShow = true

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
        // インストール後の初回表示
        .alert("\"アメダス ナウ\"が他社のアプリやWebサイトを横断してあなたのアクティビティをトラッキングすることを許可しますか？", isPresented: $isShow) {
            Button("アプリにトラッキングしないように要求") {
                isShow = false
            }
            Button("許可") {
                isShow = false
            }
        } message: {
            Text("アプリのバグ修正およびアプリの体験向上のためにユーザー行動データを利用します")
        }
    }
}

#Preview {
    ContentView()
}

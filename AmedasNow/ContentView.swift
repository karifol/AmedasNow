//
//  ContentView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/23.
//

import SwiftUI

struct ContentView: View {

    @State var selection: Int = 3
    
    var body: some View {
        TabView(selection: $selection) {
            Text("1")
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
            Text("1")
                .tabItem {
                    Image(systemName: "list.number")
                    Text("ランキング")
                }
                .tag(2)
            GraphView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("グラフ")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}

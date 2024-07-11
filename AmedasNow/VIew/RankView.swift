//
//  RankView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/07/11.
//

import SwiftUI

struct RankView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            Spacer()
        }
    }
}

extension RankView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "list.number")
            Text("ランキング")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
}

#Preview {
    ContentView()
}

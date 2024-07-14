import SwiftUI

struct RankView: View {

    var rankData = RankData()
    init(){
        rankData.serchRank()
    }

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            ScrollView {
                HStack {
                    Text(rankData.time)
                        .font(.title2)
                        .fontWeight(.bold)
                    Button {
                        rankData.serchRank()
                    } label: {
                        Text("更新")
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                    }
                }
                .padding(.top)
                
                ForEach(rankData.titleList, id: \.self) { key in
                    // テーブルタイトル
                    HStack {
                        Text(key)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                        .padding(.top)
                        .padding(.horizontal)
                    // テーブルヘッダ
                    HStack {
                        Text("順位")
                            .frame(width: 50)
                        Text("都道府県")
                            .frame(width: 100)
                        Text("観測地点")
                            .frame(width: 150)
                        Text("値")
                            .frame(width: 50)
                    }
                    .background(.gray)
                    .foregroundStyle(.white)
                    .bold()
                    // テーブルデータ
                    ForEach(rankData.dataDic[key] ?? [], id: \.id) { item in
                        HStack {
                            Text(item.rank)
                                .frame(width: 50)
                            Text(item.pref)
                                .frame(width: 100)
                            Text(item.name)
                                .frame(width: 150)
                            Text(item.value)
                                .frame(width: 50)
                        }
                        Divider()
                            .border(.black)
                            .frame(width: 350)
                    }
                }
                // 注釈
                Text("]: 統計を行う対象資料が許容範囲を超えて欠けています（資料不足値）。 値そのものを信用することはできず、通常は上位の統計に用いませんが、極値、合計、度数等の統計ではその値以上（以下）であることが確実である、といった性質を利用して統計に利用できる場合があります。")
                    .font(.caption)
                    .padding()
            }
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

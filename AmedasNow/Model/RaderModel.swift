import SwiftUI

struct RaderItem: Identifiable{
    let id = UUID()
    let baseTime: String
    let validTime: String
}

@Observable class RaderData {

    var validTimeList: [String] = [] // validtimeのデータリスト
    var beseTime:String = "" // basetime

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("RaderData.serchRank()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/jmatile/data/nowc/targetTimes_N1.json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONをパース
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)
            // データを取り出す
            validTimeList.removeAll()
            for item in result {
                if let validtime = item.validtime {
                    validTimeList.append(validtime)
                }
                if let basetime = item.basetime {
                    beseTime = basetime
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

import SwiftUI

@Observable class TunderNccData {

    var validTimeList: [String] = [] // validtimeのデータリスト

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
        let elements: [String]?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("ThunderNccData.serchRank()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/jmatile/data/nowc/targetTimes_N3.json")
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
            baseTimeList.removeAll()
            for item in result {
                if let validtime = item.validtime {
                    // thns という文字列がelementsに含まれているか
                    if let elements = item.elements {
                        if elements.contains("thns") {
                            validTimeList.append(validtime)
                        }
                    }
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

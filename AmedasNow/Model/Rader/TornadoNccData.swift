import SwiftUI

@Observable class TornadoNccData {

    var validTimeList: [String] = ["dummy", "dummy"] // validtimeのデータリスト
    var baseTimeList: [String] = ["dummy", "dummy"] // basetimeのデータリスト
    var latestTimeIndex: Int = -1

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
        let elements: [String]?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("TornadoNccData.serchRank()")
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
                    if let elements = item.elements {
                        if elements.contains("trns") {
                            validTimeList.append(validtime)
                        }
                    }
                }
                if let basetime = item.basetime {
                    if let elements = item.elements {
                        if elements.contains("trns") {
                            baseTimeList.append(basetime)
                        }
                    }
                    if let elements = item.elements {
                        if elements.contains("amds_rain10m") {
                            latestTimeIndex += 1
                        }
                    }
                }
            }
            validTimeList.sort()
            baseTimeList.sort()

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

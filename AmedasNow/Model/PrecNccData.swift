import SwiftUI

@Observable class PrecNccData {

    var validTimeList: [String] = ["dummy", "dummy"] // validtimeのデータリスト
    var baseTimeList: [String] = ["dummy", "dummy"] // basetimeのデータリスト
    var latestTimeIndex: Int = -1

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("PrecNccData.serchRank()")
        Task {
            await searchObs()
            await searchFcst()
        }
    }

    // 高解像度ナウキャストの観測データ
    @MainActor
    private func searchObs() async {
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
            baseTimeList.removeAll()
            latestTimeIndex = -1
            for item in result {
                if let validtime = item.validtime {
                    validTimeList.append(validtime)
                }
                if let basetime = item.basetime {
                    baseTimeList.append(basetime)
                }
                latestTimeIndex += 1
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }

    @MainActor
    private func searchFcst() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/jmatile/data/nowc/targetTimes_N2.json")
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
            for item in result {
                if let validtime = item.validtime {
                    validTimeList.append(validtime)
                }
                if let basetime = item.basetime {
                    baseTimeList.append(basetime)
                }
            }
            baseTimeList.sort()
            validTimeList.sort()

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

import SwiftUI

struct WeatherMapItem: Identifiable{
    let id = UUID()
    let baseTime: String
    let validTime: String
}

@Observable class WeatherMapData {

    var validTimeList: [String] = [] // validtimeのデータリスト
    var baseTime:String = "" // basetime

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("WeatherMapData.serchRank()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/jmatile/data/wdist/targetTimes.json")
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
                    baseTime = basetime
                }
            }
            // 逆順ソート
            validTimeList.sort(by: >)
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}



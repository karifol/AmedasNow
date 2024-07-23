import SwiftUI

struct RaderItem: Identifiable{
    let id = UUID()
    let baseTime: String
    let validTime: String
}

@Observable class RaderData {

    var validTimeList: [String] = [] // validtimeのデータリスト
    var baseTimeList: [String] = [] // basetimeのデータリスト
    var typeList: [Int] = []

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
            typeList.removeAll()
            for item in result {
                if let validtime = item.validtime {
                    validTimeList.append(validtime)
                }
                if let basetime = item.basetime {
                    baseTimeList.append(basetime)
                }
                typeList.append(0)
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
                typeList.append(1)
            }
            typeList.sort()
            baseTimeList.sort()
            validTimeList.sort()

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

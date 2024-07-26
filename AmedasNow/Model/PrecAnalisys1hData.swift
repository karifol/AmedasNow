import SwiftUI

@Observable class PrecAnalisys1hData {

    var validTimeList: [String] = ["dummy", "dummy"]
    var baseTimeList: [String] = ["dummy", "dummy"]
    var typeList: [String] = ["dummy", "dummy"]
    var latestTimeIndex: Int = -1

    // json構造
    struct Item: Codable {
        let basetime: String?
        let validtime: String?
        let member: String?
        let elements: [String]?
    }
    // 複数要素
    typealias ResultJson = [Item]

    func serchRank() {
        print("PrecAnalisys1hData.serchRank()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/jmatile/data/rasrf/targetTimes.json")
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
                    if let elements = item.elements {
                        if elements.contains("rasrf") {
                            validTimeList.append(validtime)
                        }
                    }
                }
                if let basetime = item.basetime {
                    if let elements = item.elements {
                        if elements.contains("rasrf") {
                            baseTimeList.append(basetime)
                        }
                        if elements.contains("rasrf") {
                            if let type = item.member {
                                typeList.append(type)
                            }
                        }
                    }
                }
                if let validtime = item.validtime {
                    if let basetime = item.basetime {
                        if validtime == basetime {
                            latestTimeIndex = latestTimeIndex + 1
                        }
                    }
                }
            }
            validTimeList.reverse()
            baseTimeList.reverse()
            typeList.reverse()

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

import SwiftUI

struct AmedasTableItem: Identifiable{
    let id = UUID()
    let amsid: String
    let lat: Double
    let lon: Double
    let name: String
    let type: String
}

@Observable class AmedasTableData {

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let type: String?
        let elems: String?
        let lat: [Double]?
        let lon: [Double]?
        let alt: Int?
        let kjName: String?
        let knName: String?
        let enName: String?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    var amedasDict: [String: AmedasTableItem] = [:]

    // Web API検索用メソッド
    func serchAmedasTable() {
        print("AmedasTableData.serchAmedasTable()")
        Task {
            await search()
        }
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func search() async {

        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/const/amedastable.json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)

            // 受け取ったJSONデータをパースして格納
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)

            amedasDict = [:]

            // 取得しているお菓子を構造体でまとめて管理
            for (key, item) in result {
                if let lat = item.lat,
                let lon = item.lon,
                let type = item.type,
                let name = item.kjName{
                let amedasItem = AmedasTableItem(
                        amsid: key,
                        lat: lat[0] + lat[1] / 60,
                        lon: lon[0] + lon[1] / 60,
                        name: name,
                        type: type
                    )
                    amedasDict[key] = amedasItem
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

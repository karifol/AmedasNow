import SwiftUI

struct AmedasMapItem: Identifiable{
    let id = UUID()
    let temp: Double
    let prec1h: Double
    let wind: Double
    let windDirection: Double
    let lat: Double
    let lon: Double
    let name: String
    let type: String
    let amsid: String
}

@Observable class AmedasMapData {

    var amedasTableData: AmedasTableData // 地点テーブルを保持するプロパティ
    // 初期化メソッド
    init(amedasTableData: AmedasTableData) {
        self.amedasTableData = amedasTableData
        amedasTableData.serchAmedasTable()
    }

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let temp: [Double?]?
        let precipitation1h: [Double?]?
        let wind: [Double?]?
        let windDirection: [Double?]?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    var amedasList: [AmedasMapItem] = []

    // Web API検索用メソッド
    func serchAmedas(basetime: String) {
        print("AmedasMapData.serchAmedas()")
        Task {
            await search(
                basetime: basetime
            )
        }
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func search( basetime: String ) async {
        var basetime2 = ""
        // basetimeが空白の場合はlatestTimeData.latestTimeを同期処理で取得
        if basetime == "999" {
            // リクエストURLの組み立て
            guard let req_url_date = URL(string: "https://www.jma.go.jp/bosai/amedas/data/latest_time.txt")
            else {
                return
            }

            do {
                // リクエストURLからダウンロード
                let (data, _) = try await URLSession.shared.data(from: req_url_date) // 2024-06-29T12:00:00+09:00
                let str = String(data: data, encoding: .utf8)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: str!)
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyyMMddHHmmss"
                basetime2 = dateFormatter2.string(from: date!)

            } catch(let error) {
                print("エラーが出ました LatestTimeData")
                print(error)
            }
        } else {
            basetime2 = basetime
        }
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/map/\(basetime2).json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONデータをパースして格納
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)
            // リストを初期化
            amedasList.removeAll()
            // 構造体でまとめて管理
            for (key, item) in result {
                if let temp = item.temp,
                let prec1h = item.precipitation1h?.first,
                let wind = item.wind,
                let windDirection = item.windDirection{
                    let amedasItem = AmedasMapItem(
                        temp: temp[0] ?? 999,
                        prec1h: prec1h ?? 999,
                        wind: wind[0] ?? 999,
                        windDirection: windDirection[0] ?? 999,
                        lat: amedasTableData.amedasDict[key]?.lat ?? 0,
                        lon: amedasTableData.amedasDict[key]?.lon ?? 0,
                        name: amedasTableData.amedasDict[key]?.name ?? "",
                        type:amedasTableData.amedasDict[key]?.type ?? "A",
                        amsid: key
                    )
                    amedasList.append(amedasItem)
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


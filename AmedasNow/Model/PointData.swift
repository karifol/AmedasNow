import SwiftUI

// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct PointItem: Identifiable{
    let id = UUID()
    let temp: Double
    let wind: Double
    let windDirection: Double
    let prec1h: Double
    let date: Date
}

@Observable class PointData {

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let temp: [Double?]?
        let precipitation1h: [Double?]?
        let wind: [Double?]?
        let windDirection: [Double?]?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    // 保持するデータ
    var dataList: [PointItem] = []
    var dataDic: [String: [PointItem]] = [:]

    // Web API検索用メソッド
    func serchAmedas(amsid: String) {
        print("PointData.serchAmedas()")
        Task {
            let latestTimeDate = await searchLatestTime()
            // リストを初期化
            dataDic.removeAll()
            // 10分ずつずらしながら60分前までのデータを取得
            for i in 0..<6 {
                let latestTime = Calendar.current.date(byAdding: .minute, value: -10 * i, to: latestTimeDate)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmss"
                let latestTimeStr = dateFormatter.string(from: latestTime)
                await search(amsid: amsid, latestTime: latestTimeStr)
            }
            dataList.removeAll()
            dataList = dataDic[amsid] ?? []
        }
    }

    func changePoint(amsid: String) {
        dataList.removeAll()
        dataList = dataDic[amsid] ?? []
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func searchLatestTime() async -> Date {
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/latest_time.txt")
        else {
            return Date()
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url) // 2024-06-29T12:00:00+09:00
            let str = String(data: data, encoding: .utf8)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let latestTime = dateFormatter.date(from: str!)!
            return latestTime

        } catch(let error) {
            print("エラーが出ました LatestTimeData")
            print(error)
            return Date()
        }
    }

    @MainActor
    private func search(amsid: String, latestTime: String) async {
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/map/\(latestTime).json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONデータをパースして格納
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)

            // 取得しているお菓子を構造体でまとめて管理
            for (key, item) in result {
                if let temp = item.temp,
                let prec1h = item.precipitation1h?.first,
                let windDirection = item.windDirection,
                let wind = item.wind{
                    
                    // 日付型の文字列をDate型に変換
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    let date = dateFormatter.date(from: latestTime)
                    
                    let amedasItem = PointItem(
                        temp: temp[0] ?? 999,
                        wind: wind[0] ?? 999,
                        windDirection: windDirection[0] ?? 999,
                        prec1h: prec1h ?? 999,
                        date: date ?? Date()
                    )
                    dataDic[key, default: []].append(amedasItem)
                }
                // sort
                dataDic[key] = dataDic[key]?.sorted(by: { $0.date < $1.date })
            }
            
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

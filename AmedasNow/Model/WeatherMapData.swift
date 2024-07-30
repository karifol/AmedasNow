
import SwiftUI

@Observable class WeatherMapData {

    var nearNow: String = ""
    var nearFt24: String = ""
    var nearFt48: String = ""
    var asiaNow: String = ""
    var asiaFt24: String = ""
    var asiaFt48: String = ""

    // json構造
    struct Near: Codable {
        let now: [String]
        let ft24: [String]
        let ft48: [String]
    }
    struct Root: Codable {
        let near: Near
        let asia: Near
    }


    func serchData() {
        print("WeatherMapData.serchData()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/weather_map/data/list.json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONをパース
            let decoder = JSONDecoder()
            let result = try decoder.decode(Root.self, from: data)
            // データを取り出す
            nearNow = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.near.now[result.near.now.count-1])"
            nearFt24 = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.near.ft24[0])"
            nearFt48 = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.near.ft48[0])"
            asiaNow = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.asia.now[result.asia.now.count-1])"
            asiaFt24 = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.asia.ft24[0])"
            asiaFt48 = "https://www.jma.go.jp/bosai/weather_map/data/png/\(result.asia.ft48[0])"
        } catch {
            print("JSONデコードエラー: \(error)")
        }
    }
}



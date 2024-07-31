import SwiftUI

@Observable class ForecastOverviewData {

    var overview: String = ""

    // JSONデータの構造に対応する構造体
    struct ResultJson: Codable {
        let publishingOffice: String
        let reportDatetime: String
        let targetArea: String
        let headlineText: String
        let text: String
    }

    func serch(id: String) {
        print("ForecastOverviewData.serch()")
        Task {
            await searchObs(id: id)
        }
    }

    // 高解像度ナウキャストの観測データ
    @MainActor
    private func searchObs(id: String) async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/forecast/data/overview_forecast/\(id).json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONをパース
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)
            overview = result.text

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


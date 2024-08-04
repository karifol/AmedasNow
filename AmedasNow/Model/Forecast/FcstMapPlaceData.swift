import SwiftUI

@Observable class FcstMapPlaceData {

    var idList: [String] = []
    var latList: [Double] = []
    var lonList: [Double] = []
    var nameList: [String] = []
    var typeList: [String] = []
    var prefList: [String] = []

    // json構造
    struct Item : Codable {
        var name: String
        var lat: Double
        var lon: Double
        var parent_id: String
        var type: String
        var pref: String
    }
    typealias ResultJson = [Int: Item]

    func serchAsync() {
        print("FcstMapPlaceData.serchAsync()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        guard let path = Bundle.main.path(forResource: "forecast_japan", ofType: "json") else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)
            // パースしたデータを格納
            for (key, value) in result {
                // 6桁0埋め
                let id = String(format: "%06d", key)
                idList.append(id)
                latList.append(value.lat)
                lonList.append(value.lon)
                prefList.append(value.pref)
                nameList.append(value.name)
                typeList.append(value.type)
            }

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


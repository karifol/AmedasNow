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
    typealias ResultJson = [String: Item]

    var amedasDict: [String: AmedasTableItem] = [:]

    func serchAmedasTable() {
        print("AmedasTableData.serchAmedasTable()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {

        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/const/amedastable.json")
        else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: req_url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)

            amedasDict = [:]

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

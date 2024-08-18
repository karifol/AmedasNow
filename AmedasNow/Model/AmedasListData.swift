import SwiftUI

@Observable class AmedasListData {
    
    var nameList: [String] = [""]
    var latList: [Double] = []
    var lonList: [Double] = []

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

            nameList.removeAll()
            latList.removeAll()
            lonList.removeAll()

            for (_, item) in result {
                if let lat = item.lat,
                let lon = item.lon,
                let name = item.kjName{
                    nameList.append(name)
                    latList.append(lat[0] + lat[1] / 60)
                    lonList.append(lon[0] + lon[1] / 60)
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

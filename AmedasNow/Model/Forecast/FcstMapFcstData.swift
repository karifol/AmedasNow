import SwiftUI

@Observable class FcstMapFcstData {

    var validTimeList: [String] = ["dummy", "dummy"]

    var class10_vtList: [String] = []
    var class10_wxDict: [String: [String: String]] = [:]

    var office_vtList: [String] = []
    var office_wxDict: [String: [String: String]] = [:]

    var all_vtList: [String] = []

    // 複数要素
    typealias ResultJson = [[Item]]
    // json構造
    struct Item: Codable {
        let reportDatetime: String
        let timeSeries: [TimeSeries]
    }
    struct TimeSeries: Codable {
        let timeDefines: [String]
        let areas: [Area]
    }
    struct Area: Codable {
        let area: AreaInfo
        let weatherCodes: [String]?

    }
    struct AreaInfo: Codable {
        let name: String
        let code: String
    }

    func serchAsync() {
        print("FcstMapFcst.serchAsync()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/map.json")
        else {
            return
        }
        do {
            // ダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)

            // class10 valid time
            class10_vtList.removeAll()
            for date in result[0][0].timeSeries[0].timeDefines { // "2024-08-04T11:00:00+09:00"
                // 2024-08-04T11:00:00+09:00 -> 5日
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: date)
                let outputFormatter = DateFormatter()
                // 日にちと曜日を取得
                outputFormatter.dateFormat = "d日"
                let outputDate = outputFormatter.string(from: date!)
                class10_vtList.append(outputDate)
            }

            // class10 weather
            for area in result {
                for place in area[0].timeSeries[0].areas {
                    class10_wxDict[place.area.code] = [:]
                    for (i, date) in place.weatherCodes!.enumerated() {
                        class10_wxDict[place.area.code]![class10_vtList[i]] = date
                    }
                }
            }

            // office valid time
            office_vtList.removeAll()
            for date in result[0][1].timeSeries[0].timeDefines { // "2024-08-04T11:00:00+09:00"
                // 2024-08-04T11:00:00+09:00 -> 5日
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: date)
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "d日"
                let outputDate = outputFormatter.string(from: date!)
                office_vtList.append(outputDate)
            }

            // office weather
            for area in result {
                for place in area[1].timeSeries[0].areas {
                    office_wxDict[place.area.code] = [:]
                    for (i, date) in place.weatherCodes!.enumerated() {
                        office_wxDict[place.area.code]![office_vtList[i]] = date
                    }
                }
            }

            // all_vtList
            var _all_vtList: [Int] = []
            for date in result[0][0].timeSeries[0].timeDefines { // "2024-08-04T11:00:00+09:00"
                // 2024-08-04T11:00:00+09:00 -> 5日
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: date)
                formatter.dateFormat = "MMdd"
                let outputDate = Int(formatter.string(from: date!))
                _all_vtList.append(outputDate!)
            }
            for date in result[0][1].timeSeries[0].timeDefines { // "2024-08-04T11:00:00+09:00"
                // 2024-08-04T11:00:00+09:00 -> 5日
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = formatter.date(from: date)
                formatter.dateFormat = "MMdd"
                let outputDate = Int(formatter.string(from: date!))
                _all_vtList.append(outputDate!)
            }
            _all_vtList = Array(Set(_all_vtList))
            _all_vtList.sort()
            all_vtList.removeAll()
            for date in _all_vtList { // 804
                let day = date % 100
                all_vtList.append(String(day) + "日")
            }

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


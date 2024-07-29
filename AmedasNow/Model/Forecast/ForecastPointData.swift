import SwiftUI

@Observable class ForecastPointData {

    var validTimeList: [String] = ["dummy", "dummy"]
    var srf_wx_timeDifines: [String] = []
    var srf_areaName: [String] = []
    var srf_wxCode: [[String]] = []
    var srf_wxName: [[String]] = []
    var srf_wxWind: [[String]] = []
    
    // 複数要素
    typealias ResultJson = [Item]
    // json構造
    struct Item: Codable {
        let publishingOffice: String
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
        let weathers: [String]?
        let winds: [String]?
        let pops: [String]?
        let reliabilities: [String]?
        let temps: [String]?
        let tempsMin: [String]?
        let tempsMinUpper: [String]?
        let tempsMinLower: [String]?
        let tempsMax: [String]?
        let tempsMaxUpper: [String]?
        let tempsMaxLower: [String]?
    }
    struct AreaInfo: Codable {
        let name: String
        let code: String
    }

    func serch(id: String) {
        print("ForecastPointData.serch()")
        Task {
            await searchObs(id: id)
        }
    }

    // 高解像度ナウキャストの観測データ
    @MainActor
    private func searchObs(id: String) async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/100000.json")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったJSONをパース
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)
            
            srf_wx_timeDifines.removeAll()
            
            // Short Range Forecast
            let srf = result[0]
            let srf_wx = srf.timeSeries[0]
            // time
            for date in srf_wx.timeDefines { // 2024-07-30T00:00:00+09:00
                srf_wx_timeDifines.append(date)
            }
            // area name
            for areaData in srf_wx.areas {
                srf_areaName.append(areaData.area.name)
                // wx code
                var _wxcodeList:[String] = []
                guard let wxCodeList = areaData.weatherCodes else {
                    continue
                }
                for wxCode in wxCodeList {
                    _wxcodeList.append(wxCode)
                }
                srf_wxCode.append(_wxcodeList)
                // wx name
                var _wxnameList:[String] = []
                guard let wxNameList = areaData.weathers else {
                    continue
                }
                for wxName in wxNameList {
                    _wxnameList.append(wxName)
                }
                srf_wxName.append(_wxnameList)
                // wind
                var _windList:[String] = []
                guard let windList = areaData.winds else {
                    continue
                }
                for wind in windList {
                    _windList.append(wind)
                }
                srf_wxWind.append(_windList)
            }
            
            print(srf_wx_timeDifines)
            print(srf_areaName)
            print(srf_wxCode)
            print(srf_wxName)
            print(srf_wxWind)
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


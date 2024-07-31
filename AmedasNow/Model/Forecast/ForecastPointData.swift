import SwiftUI

@Observable class ForecastPointData {

    var validTimeList: [String] = ["dummy", "dummy"]
    var srf_wx_timeDifines: [String] = []
    var srf_areaName: [String] = []
    var srf_wxCode: [String: [String: String]] = [:]
    var srf_wxName: [String: [String: String]] = [:]
    var srf_wxWind: [String: [String: String]] = [:]
    var srf_tmp_timeDifines: [String] = []
    var srf_tmpTemp: [String: [String: [String: String]]] = [:]
    
    var mrf_wx_timeDifines: [String] = []
    var mrf_areaName: [String] = []
    var mrf_wxCode: [String: [String: String]] = [:]
    var mrf_wxPop: [String: [String: String]] = [:]
    var mrf_wxReliability: [String: [String: String]] = [:]
    var mrf_tmpMax: [String: [String: String]] = [:]
    var mrf_tmpMin: [String: [String: String]] = [:]
    
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
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/\(id).json")
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
            // srf weather
            let srf_wx = srf.timeSeries[0]
            // time
            for date in srf_wx.timeDefines { // 2024-07-30T00:00:00+09:00
                // 今日、明日、明後日に分類する
                let dateStr = date.components(separatedBy: "T")[0]
                // 日本時間の今日
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!
                let dateFormatter = DateFormatter()
                // yyyy-MM-ddに変換
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayStr = dateFormatter.string(from: today)
                let tomorrowStr = dateFormatter.string(from: tomorrow)
                let dayAfterTomorrowStr = dateFormatter.string(from: dayAfterTomorrow)
                // 今日、明日、明後日のみ取得
                if dateStr == todayStr {
                    srf_wx_timeDifines.append("今日")
                } else if dateStr == tomorrowStr {
                    srf_wx_timeDifines.append("明日")
                } else if dateStr == dayAfterTomorrowStr {
                    srf_wx_timeDifines.append("明後日")
                }
            }
            // area
            for idx in 0..<srf_wx.areas.count {
                let areaData = srf_wx.areas[idx]
                let areaName = areaData.area.name
                // area name
                srf_areaName.append(areaName)
                // wx code
                guard let wxCodeList = areaData.weatherCodes else {
                    continue
                }
                srf_wxCode[areaName] = [:]
                for idx2 in 0..<wxCodeList.count {
                    let key = srf_wx_timeDifines[idx2]
                    srf_wxCode[areaName]?[key] = wxCodeList[idx2]
                }
                // wx name
                guard let wxNameList = areaData.weathers else {
                    continue
                }
                srf_wxName[areaName] = [:]
                for idx2 in 0..<wxNameList.count {
                    let key = srf_wx_timeDifines[idx2]
                    srf_wxName[areaName]?[key] = wxNameList[idx2]
                }
                // wind
                guard let wxWindList = areaData.winds else {
                    continue
                }
                srf_wxWind[areaName] = [:]
                for idx2 in 0..<wxWindList.count {
                    let key = srf_wx_timeDifines[idx2]
                    srf_wxWind[areaName]?[key] = wxWindList[idx2]
                }
            }

            // srf tmp
            let srf_tmp = srf.timeSeries[2]
            // time
            for date in srf_tmp.timeDefines { // 2024-07-30T09:00:00+09:00
                // 今日、明日、明後日に分類する
                // 9:00データは最高気温、0:00データは最低気温にぶんるいする
                let dateStr = date.components(separatedBy: "T")[0]
                // 日本時間の今日
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!
                let dateFormatter = DateFormatter()
                // yyyy-MM-ddに変換
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayStr = dateFormatter.string(from: today)
                let tomorrowStr = dateFormatter.string(from: tomorrow)
                let dayAfterTomorrowStr = dateFormatter.string(from: dayAfterTomorrow)
                // 今日、明日、明後日のみ取得
                if dateStr == todayStr {
                    let time = date.components(separatedBy: "T")[1].components(separatedBy: ":")[0]
                    if time == "09" {
                        srf_tmp_timeDifines.append("今日の最高気温")
                    } else if time == "00" {
                        srf_tmp_timeDifines.append("今日の最低気温")
                    }
                } else if dateStr == tomorrowStr {
                    let time = date.components(separatedBy: "T")[1].components(separatedBy: ":")[0]
                    if time == "09" {
                        srf_tmp_timeDifines.append("明日の最高気温")
                    } else if time == "00" {
                        srf_tmp_timeDifines.append("明日の最低気温")
                    }
                } else if dateStr == dayAfterTomorrowStr {
                    let time = date.components(separatedBy: "T")[1].components(separatedBy: ":")[0]
                    if time == "09" {
                        srf_tmp_timeDifines.append("明後日の最高気温")
                    } else if time == "00" {
                        srf_tmp_timeDifines.append("明後日の最低気温")
                    }
                }
            }
            // area
            for idx in 0..<srf_wx.areas.count {
                let areaData = srf_tmp.areas[idx]
                let areaName = srf_wx.areas[idx].area.name
                // temp
                guard let tmpTempList = areaData.temps else {
                    continue
                }
                srf_tmpTemp[areaName] = [:]
                for date in srf_wx_timeDifines { // 今日
                    srf_tmpTemp[areaName]?[date] = [:]
                    srf_tmpTemp[areaName]?[date]?["max"] = "-"
                    srf_tmpTemp[areaName]?[date]?["min"] = "-"
                    // srf_tmp_timeDifinesには「今日の最高気温」などが入っているかどうか
                    guard let idx = srf_tmp_timeDifines.firstIndex(of: "\(date)の最高気温") else {
                        continue
                    }
                    let maxTemp = tmpTempList[idx]
                    srf_tmpTemp[areaName]?[date]?["max"] = maxTemp
                    // srf_tmp_timeDifinesには「今日の最低気温」などが入っているかどうか
                    guard let idx = srf_tmp_timeDifines.firstIndex(of: "\(date)の最低気温") else {
                        continue
                    }
                    let minTemp = tmpTempList[idx]
                    srf_tmpTemp[areaName]?[date]?["min"] = minTemp
                }
            }
            
            // Mid Range Forecast
            let mrf = result[1]
            // mrf weather
            let mrf_wx = mrf.timeSeries[0]
            // mrf temp
            let mrf_tmp = mrf.timeSeries[1]
            // time
            for date in mrf_wx.timeDefines { // 2024-07-30T00:00:00+09:00
                // 今日、明日、明後日に分類する
                let dateStr = date.components(separatedBy: "T")[0] // 2024-07-30
                let dayStr = dateStr.components(separatedBy: "-")[2]
                
                mrf_wx_timeDifines.append(dayStr + "日")
            }
            // area
            for idx in 0..<mrf_wx.areas.count {
                let areaData = mrf_wx.areas[idx]
                let areaTempData = mrf_tmp.areas[idx]
                let areaName = areaData.area.name
                // area name
                mrf_areaName.append(areaName)
                // wx code
                guard let wxCodeList = areaData.weatherCodes else {
                    continue
                }
                mrf_wxCode[areaName] = [:]
                for idx2 in 0..<wxCodeList.count {
                    let key = mrf_wx_timeDifines[idx2]
                    mrf_wxCode[areaName]?[key] = wxCodeList[idx2]
                }
                // pop
                guard let wxPopList = areaData.pops else {
                    continue
                }
                mrf_wxPop[areaName] = [:]
                for idx2 in 0..<wxCodeList.count {
                    let key = mrf_wx_timeDifines[idx2]
                    mrf_wxPop[areaName]?[key] = wxPopList[idx2] == "" ? "-" : wxPopList[idx2] + "%"
                }
                // rel
                guard let wxRelList = areaData.reliabilities else {
                    continue
                }
                mrf_wxReliability[areaName] = [:]
                for idx2 in 0..<wxRelList.count {
                    let key = mrf_wx_timeDifines[idx2]
                    mrf_wxReliability[areaName]?[key] = wxRelList[idx2] == "" ? "-" : wxRelList[idx2]
                }
                // max temp
                guard let tmpMaxList = areaTempData.tempsMax else {
                    continue
                }
                mrf_tmpMax[areaName] = [:]
                for idx2 in 0..<tmpMaxList.count {
                    let key = mrf_wx_timeDifines[idx2]
                    mrf_tmpMax[areaName]?[key] = tmpMaxList[idx2] == "" ? "-" : tmpMaxList[idx2] + "℃"
                }
                // min temp
                guard let tmpMinList = areaTempData.tempsMin else {
                    continue
                }
                mrf_tmpMin[areaName] = [:]
                for idx2 in 0..<tmpMinList.count {
                    let key = mrf_wx_timeDifines[idx2]
                    mrf_tmpMin[areaName]?[key] = tmpMinList[idx2] == "" ? "-" : tmpMinList[idx2] + "℃"
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


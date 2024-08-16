import SwiftUI

@Observable class ModelData {
    
    var timeList: [String] = []
    var hourList: [String] = []
    var tempList: [String] = []
    var precList: [String] = []

    // JSONデータの構造に対応するSwiftの構造体
    struct Forecast: Codable {
        let latitude: Double
        let longitude: Double
        let generationtime_ms: Double
        let utc_offset_seconds: Int
        let timezone: String
        let timezone_abbreviation: String
        let elevation: Double
        let hourly_units: HourlyUnits
        let hourly: HourlyData
    }

    struct HourlyUnits: Codable {
        let time: String
        let temperature_2m: String
        let precipitation: String
    }

    struct HourlyData: Codable {
        let time: [String]
        let temperature_2m: [Double]
        let precipitation: [Double]
    }


    func serch(model: String) {
        print("AmedasTableData.serchAmedasTable()")
        Task {
            await searchAsync(model: model)
        }
    }

    @MainActor
    private func searchAsync(model: String) async {
        guard let req_url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=35.6895&longitude=139.6917&hourly=temperature_2m,precipitation&forecast_days=7&models=\(model)")
        else {
            return
        }
        do {
            timeList.removeAll()
            hourList.removeAll()
            tempList.removeAll()
            precList.removeAll()
            let (data, _) = try await URLSession.shared.data(from: req_url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(Forecast.self, from: data)
            for time in result.hourly.time { // 2024-08-19T20:00
                // mm/dd
                let mm = time.split(separator: "-")[1]
                let dd = time.split(separator: "-")[2].split(separator: "T")[0]
                let hour = time.split(separator: "T")[1]
                timeList.append("\(mm)/\(dd)")
                hourList.append("\(hour)")
            }
            tempList = result.hourly.temperature_2m.map { String($0) }
            precList = result.hourly.precipitation.map { String($0) }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

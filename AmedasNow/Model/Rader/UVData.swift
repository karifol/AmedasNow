import SwiftUI

@Observable class UVData {

    var validTimeList: [String] = [] // validtimeのデータリスト
    var basetime: String = ""
    var uyy: Int? // 2024
    var umm: Int? // 07
    var udd: Int? // 23
    var uhh: Int? // 06

    func serchRank() {
        print("UVData.serchRank()")
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.data.jma.go.jp/gmd/env/uvindex/uvjs/updatetime_uvi_f.js") // 紫外線の予測
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったデータを文字列に変換
            if let content = String(data: data, encoding: .utf8) {
                // 正規表現で変数を抽出
                extractVariables(from: content)
                // BASETIME
                makeBaseTime()
                // 1時間ごとに13時間分のデータを作成
                makeValidTimeList()
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }

    private func extractVariables(from content: String) {
        let patterns = [
            "uyy = (\\d+);",
            "umm = (\\d+);",
            "udd = (\\d+);",
            "uhh = (\\d+);"
        ]
        for pattern in patterns {
            if let match = content.range(of: pattern, options: .regularExpression) {
                let value = content[match].split(separator: "=")[1].trimmingCharacters(in: .whitespacesAndNewlines).dropLast()
                switch pattern {
                case "uyy = (\\d+);":
                    uyy = Int(value)
                case "umm = (\\d+);":
                    umm = Int(value)
                case "udd = (\\d+);":
                    udd = Int(value)
                case "uhh = (\\d+);":
                    uhh = Int(value)
                default:
                    break
                }
            }
        }
    }

    private func makeBaseTime() {
        guard let uyy = uyy, let umm = umm, let udd = udd else {
            return
        }
        let date = DateComponents(calendar: .current, year: uyy, month: umm, day: udd, hour: 12)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        if var date = date.date{
            // 1日前の12Z
            date.addTimeInterval(-24 * 60 * 60)
            basetime = formatter.string(from: date)
        }
    }

    private func makeValidTimeList() {
        guard let uyy = uyy, let umm = umm, let udd = udd, let uhh = uhh else {
            return
        }
        let date = DateComponents(calendar: .current, year: uyy, month: umm, day: udd, hour: uhh)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        for i in 0..<13 {
            if var date = date.date {
                // 9時間前
                 date.addTimeInterval(-9 * 60 * 60)
                // i時間後
                date.addTimeInterval(TimeInterval(i * 60 * 60))
                validTimeList.append(formatter.string(from: date))
            }
        }
        validTimeList.sort()
    }
}



//
//  PointData.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/30.
//

import SwiftUI


// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct PointItem: Identifiable{
    let id = UUID()
    let temp: Double
    let wind: Double
    let prec1h: Double
    let date: Date
}

@Observable class PointData {

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let prefNumber: Double?
        let observationNumber: Double?
        let temp: [Double]?
        let precipitation1h: [Double]?
        let wind: [Double]?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    var dataList: [PointItem] = []

    // Web API検索用メソッド
    func serchAmedas(amsid: String) {
        // Taskは非同期で処理を実行できる
        Task {
            let latestTime = await searchLatestTime()
            await search(amsid: amsid, latestTime: latestTime)
        }
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func searchLatestTime() async -> String {

        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/latest_time.txt")
        else {
            return ""
        }

        print(req_url)

        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url) // 2024-06-29T12:00:00+09:00
            let str = String(data: data, encoding: .utf8)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let latestTime = dateFormatter.date(from: str!)!
            // 3時間前のデータを取得する
            let latestTime3hAgo = latestTime.addingTimeInterval(-3*60*60)
            dateFormatter.dateFormat = "yyyyMMdd_HH"
            let latestTimeStr = dateFormatter.string(from: latestTime3hAgo)
            return latestTimeStr

        } catch(let error) {
            print("エラーが出ました LatestTimeData")
            print(error)
            return ""
        }
    }

    @MainActor
    private func search(amsid: String, latestTime: String) async {
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/point/\(amsid)/\(latestTime).json")
        else {
            return
        }

        print(req_url)

        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)

            // 受け取ったJSONデータをパースして格納
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultJson.self, from: data)

            // お菓子のリストを初期化
            dataList.removeAll()

            // 取得しているお菓子を構造体でまとめて管理
            for (key, item) in result {
                if let temp = item.temp,
                    let wind = item.wind,
                   let prec1h = item.precipitation1h{

                    // 日付型の文字列をDate型に変換
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    let date = dateFormatter.date(from: key)
                    dateFormatter.dateFormat = "HH:mm"
                    let dateStr = dateFormatter.string(from: date!)

                    let amedasItem = PointItem(
                        temp: temp[0],
                        wind: wind[0],
                        prec1h: prec1h[0],
                        date: date ?? Date()
                    )
                    dataList.append(amedasItem)
                }
            }

            dataList.sort { $0.date < $1.date }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


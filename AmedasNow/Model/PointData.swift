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
    let date: String
}

@Observable class PointData {

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let prefNumber: Double?
        let observationNumber: Double?
        let temp: [Double]?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    var dataList: [PointItem] = []

    // Web API検索用メソッド
    func serchAmedas() {
        // Taskは非同期で処理を実行できる
        Task {
            await search()
        }
    }

    @MainActor
    private func search() async {

        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/point/44132/20240630_09.json")
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
                if let temp = item.temp{

                    // 日付型の文字列をDate型に変換
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    let date = dateFormatter.date(from: key)
                    dateFormatter.dateFormat = "HH:mm"
                    let dateStr = dateFormatter.string(from: date!)

                    let amedasItem = PointItem(
                        temp: temp[0],
                        date: dateStr // 20240630090000
                    )
                    print(dateStr)
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


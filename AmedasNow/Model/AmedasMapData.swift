//
//  AmedasMapData.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/28.
//

import SwiftUI

struct AmedasMapItem: Identifiable{
    let id = UUID()
    let temp: Double
    let prec1h: Double
    let wind: Double
    let windDirection: Double
    let lat: Double
    let lon: Double
    let name: String
    let type: String
}

@Observable class AmedasMapData {


    var amedasTableData: AmedasTableData // 地点テーブルを保持するプロパティ
    // 初期化メソッド
    init(amedasTableData: AmedasTableData) {
        self.amedasTableData = amedasTableData
        amedasTableData.serchAmedasTable()
    }

    // JSONのitem内のデータ構造
    struct Item: Codable {
        let temp: [Double?]?
        let precipitation1h: [Double?]?
        let wind: [Double?]?
        let windDirection: [Double?]?
    }
    // 複数要素
    typealias ResultJson = [String: Item]

    var amedasList: [AmedasMapItem] = []

    // Web API検索用メソッド
    func serchAmedas(
        basetime: String
    ) {
        // Taskは非同期で処理を実行できる
        Task {
            // ここから先は非同期で実行される
            // 非同期でお菓子を検索する
            await search(
                basetime: basetime
            )
        }
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func search(
        basetime: String
    ) async {

        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/map/\(basetime).json")
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
            amedasList.removeAll()

            // 取得しているお菓子を構造体でまとめて管理
            for (key, item) in result {
                if let temp = item.temp,
                let prec1h = item.precipitation1h?.first,
                let wind = item.wind,
                let windDirection = item.windDirection{
                    let amedasItem = AmedasMapItem(
                        temp: temp[0] ?? 999,
                        prec1h: prec1h ?? 999,
                        wind: wind[0] ?? 999,
                        windDirection: windDirection[0] ?? 999,
                        lat: amedasTableData.amedasDict[key]?.lat ?? 0,
                        lon: amedasTableData.amedasDict[key]?.lon ?? 0,
                        name: amedasTableData.amedasDict[key]?.name ?? "",
                        type:amedasTableData.amedasDict[key]?.type ?? "A"
                    )
                    amedasList.append(amedasItem)
                }

            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


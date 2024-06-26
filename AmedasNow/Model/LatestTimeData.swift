//
//  LatestTimeData.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/26.
//

import SwiftUI

// Identifiableプロトコルを利用して、お菓子の情報をまとめる構造体
struct latestTime: Identifiable{
    let id = UUID()
    let lat: Double
    let lon: Double
    let name: String
    let type: String
}

// お菓子データ検索用のクラス
@Observable class LatestTimeData {
    
    var latestTIme: String = ""
    
    // Web API検索用メソッド
    func serchLatestTime() {
        // Taskは非同期で処理を実行できる
        Task {
            // ここから先は非同期で実行される
            // 非同期でお菓子を検索する
            await search()
        }
    }

    // @MainActorを使いメインスレッドで更新する
    @MainActor
    private func search() async {

        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://www.jma.go.jp/bosai/amedas/data/latest_time.txt")
        else {
            return
        }
        
        print(req_url)

        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            latestTIme = String(data: data, encoding: .utf8) ?? ""
            print(latestTIme)

        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}


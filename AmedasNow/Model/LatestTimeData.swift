import SwiftUI

class LatestTimeData: ObservableObject {

    @Published var latestTime: Date = Date()

    // Web API検索用メソッド
    func get() {
        print("LatestTimeData.get()")
        Task {
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
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url) // 2024-06-29T12:00:00+09:00
            let str = String(data: data, encoding: .utf8)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            latestTime = dateFormatter.date(from: str!)!

        } catch(let error) {
            print("エラーが出ました LatestTimeData")
            print(error)
        }
    }
}


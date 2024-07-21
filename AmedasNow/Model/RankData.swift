import SwiftUI
import SwiftSoup

struct RankItem: Identifiable{
    let id = UUID()
    let rank: String
    let pref: String
    let city: String
    let name: String
    let value: String
}

@Observable class RankData {

    var dataDic: [String: [RankItem]] = [:]
    var titleList: [String] = []
    var time: String = ""
    var href: String = "" // data0714.html

    func serchRank() {
        print("RankData.serchRank()")
        Task {
            await today()
            await search()
        }
    }
    
    @MainActor
    private func today() async {
        guard let req_url = URL(string: "https://www.data.jma.go.jp/stats/data/mdrr/rank_daily/index.html")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったHTMLをパース
            let html = String(data: data, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html ?? "")
            // <ul class='contentslink ltx'>のulを取得
            let ul: Elements = try doc.select("ul.contentslink.ltx")
            // <ul class='contentslink ltx'>のliを取得
            let li: Elements = try ul.select("li")
            // <ul class='contentslink ltx'>のliのaを取得
            let a: Elements = try li.select("a")
            // <ul class='contentslink ltx'>のliのaのhrefを取得
            href = try a.attr("href") // data0714.html
            
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }

    @MainActor
    private func search() async {
        // 日ランキング
        guard let req_url = URL(string: "https://www.data.jma.go.jp/obd/stats/data/mdrr/rank_daily/\(href)")
        else {
            return
        }
        do {
            // リクエストURLからダウンロード
            let (data, _) = try await URLSession.shared.data(from: req_url)
            // 受け取ったHTMLをパース
            let html = String(data: data, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html ?? "")
            // <span class="ex2">11時00分現在</span>を取得
            let time = try doc.select("span.ex2").text()
            self.time = time
            // テーブルを取得
            let table: Elements = try doc.select("table")
            // テーブルが存在するか確認
            guard !table.isEmpty else {
                print("テーブルが見つかりませんでした")
                return
            }

            // テーブルごとに処理
            for i in 0..<table.count {
                // tableのsummary属性を取得
                let summary = try table.get(i).attr("summary")
                
                // テーブルの行を取得
                let rows: Elements = try table.get(i).select("tr")
                
                // テーブルの行ごとに処理
                var prevRank = ""
                // リセット
                
                if (rows.count == 0) {
                    continue
                }
                dataDic[summary] = []
                for j in 0..<rows.count {
                    // テーブルの列を取得
                    let cols: Elements = try rows.get(j).select("td")

                    guard cols.count >= 5 else {
                        continue
                    }
                    if cols.count == 0 {
                        continue
                    }
                    var rank = try cols.get(0).text()
                    if rank == "〃" {
                        rank = prevRank
                    }
                    prevRank = rank
                    let pref = try cols.get(1).text()
                    let city = try cols.get(2).text()
                    let name = try cols.get(3).text()
                    let value = try cols.get(4).text()

                    let item = RankItem(rank: rank, pref: pref, city: city, name: name, value: value)
                    if dataDic[summary] == nil {
                        dataDic[summary] = [item]
                    } else {
                        dataDic[summary]?.append(item)
                    }
                }
                titleList.append(summary)
                // sort
                dataDic[summary]?.sort { (a, b) -> Bool in
                    return Int(a.rank)! < Int(b.rank)!
                }
            }
        } catch(let error) {
            print("エラーが出ました")
            print(error)
        }
    }
}

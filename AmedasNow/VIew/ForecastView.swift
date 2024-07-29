import SwiftUI

struct ForecastView: View {
    @State var prefId: String = ""
    @State var prefName: String = ""
    var body: some View {
        if prefId == "" {
            VStack (alignment: .center, spacing: 0){
                HeaderView
                ScrollView{
                    ForeacastMenue
                }
            }
            .onChange(of: prefId) {
                print(prefId)
            }
        } else {
            ForecastPrefView(id: prefId, prefName: prefName)
        }
    }
}

extension ForecastView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "cloud.sun.rain")
            Text("天気予報")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
    
    private var ForeacastMenue: some View {
        VStack {
            Text("北海道")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "宗谷", id: "011000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "上川・留萌", id: "012000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "網走・北見・紋別", id: "013000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "十勝", id: "014030")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "釧路・根室", id: "014100")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "群馬・日高", id: "015000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "石狩・空知・後志", id: "016000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hokkaidou", title: "渡島・檜山", id: "017000")
            }
            Divider()
            Text("東北")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "aomori", title: "青森県", id: "020000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "akita", title: "秋田県", id: "050000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "iwate", title: "岩手県", id: "030000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "yamagata", title: "山形県", id: "060000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "miyagi", title: "宮城県", id: "040000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "fukushima", title: "福島県", id: "070000")
            }
            Divider()

            Text("関東甲信")
                .font(.title)
                .bold()
                .padding(.top)
            MenueButton(prefId: $prefId, prefName: $prefName, imageName: "tokyo", title: "東京都", id: "130000")
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "tochigi", title: "栃木県", id: "090000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "gunma", title: "群馬県", id: "100000")
            }
            HStack {

                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "saitama", title: "埼玉県", id: "110000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "ibaraki", title: "茨城県", id: "080000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "chiba", title: "千葉県", id: "120000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kanagawa", title: "神奈川県", id: "140000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "nagano", title: "長野県", id: "200000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "yamanashi", title: "山梨県", id: "190000")
            }
            Text("北陸")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "niigata", title: "新潟県", id: "150000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "toyama", title: "富山県", id: "160000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "ishikawa", title: "石川県", id: "170000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "fukui", title: "福井県", id: "180000")
            }
            Divider()
            Text("東海")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "aichi", title: "愛知県", id: "230000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "gifu", title: "岐阜県", id: "210000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "mie", title: "三重県", id: "240000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "shizuoka", title: "静岡県", id: "220000")
            }
            Divider()
            Text("近畿")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kyouto", title: "京都府", id: "260000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "osaka", title: "大阪府", id: "270000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hyougo", title: "兵庫県", id: "280000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "nara", title: "奈良県", id: "290000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "shiga", title: "滋賀県", id: "250000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "wakayama", title: "和歌山県", id: "300000")
            }
            Divider()
            Text("中国")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "tottori", title: "鳥取県", id: "310000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "shimane", title: "島根県", id: "320000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "okayama", title: "岡山県", id: "330000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "hiroshima", title: "広島県", id: "340000")
            }
            Divider()
            Text("四国")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kagawa", title: "香川県", id: "3760000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "ehime", title: "愛媛県", id: "380000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "tokushima", title: "徳島県", id: "360000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kouchi", title: "高知県", id: "390000")
            }
            Divider()
            Text("九州北部")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "yamaguchi", title: "山口県", id: "350000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "fukuoka", title: "福岡県", id: "400000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "ooita", title: "大分県", id: "440000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "saga", title: "佐賀県", id: "410000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "nagasaki", title: "長崎県", id: "420000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kumamoto", title: "熊本県", id: "430000")
            }
            Divider()
            Text("九州南部・奄美")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "miyazaki", title: "宮崎県", id: "450000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kagoshima", title: "鹿児島県", id: "460100")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "kagoshima", title: "奄美", id: "460040")
            }
            Divider()
            Text("沖縄")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "okinawa", title: "沖縄県", id: "471000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "okinawa", title: "大東島", id: "472000")
            }
            HStack {
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "okinawa", title: "宮古島", id: "473000")
                MenueButton(prefId: $prefId, prefName: $prefName, imageName: "okinawa", title: "八重山", id: "474000")
            }


        }
    }
    
    struct MenueButton: View {
        @Binding var prefId: String
        @Binding var prefName: String
        let imageName: String
        let title: String
        let id: String
        var body: some View {
            Button {
                prefId = id
                prefName = title
            } label: {
                HStack{
                    Image(imageName)
                        .resizable()
                        .frame(width: imageName=="hokkaidou" ? 40 : 50, height: imageName=="hokkaidou" ? 30 : 50)
                    Text(title)
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.black)
                .frame(width: 150, height: 60)
                .background(.gray.opacity(0.1))
            }
        }
    }
}

#Preview {
    ForecastView()
}

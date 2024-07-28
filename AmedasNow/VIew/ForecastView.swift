import SwiftUI

struct ForecastView: View {


    var body: some View {
        VStack (alignment: .center, spacing: 0){
            HeaderView
            ScrollView{
                ForeacastMenue
            }
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
            MenueButton(imageName: "hokkaidou", title: "北海道")
            Divider()
            Text("東北")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "aomori", title: "青森県")
                MenueButton(imageName: "akita", title: "秋田県")
            }
            HStack {
                MenueButton(imageName: "iwate", title: "岩手県")
                MenueButton(imageName: "yamagata", title: "山形県")
            }
            HStack {
                MenueButton(imageName: "miyagi", title: "宮城県")
                MenueButton(imageName: "fukushima", title: "福島県")
            }
            Divider()

            Text("関東甲信")
                .font(.title)
                .bold()
                .padding(.top)
            MenueButton(imageName: "tokyo", title: "東京都")
            HStack {
                MenueButton(imageName: "tochigi", title: "栃木県")
                MenueButton(imageName: "gunma", title: "群馬県")
            }
            HStack {

                MenueButton(imageName: "saitama", title: "埼玉県")
                MenueButton(imageName: "ibaraki", title: "茨城県")
            }
            HStack {
                MenueButton(imageName: "chiba", title: "千葉県")
                MenueButton(imageName: "kanagawa", title: "神奈川県")
            }
            HStack {
                MenueButton(imageName: "nagano", title: "長野県")
                MenueButton(imageName: "yamanashi", title: "山梨県")
            }
            Text("北陸")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "niigata", title: "新潟県")
                MenueButton(imageName: "toyama", title: "富山県")
            }
            HStack {
                MenueButton(imageName: "ishikawa", title: "石川県")
                MenueButton(imageName: "fukui", title: "福井県")
            }
            Divider()
            Text("東海")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "aichi", title: "愛知県")
                MenueButton(imageName: "gifu", title: "岐阜県")
            }
            HStack {
                MenueButton(imageName: "mie", title: "三重県")
                MenueButton(imageName: "shizuoka", title: "静岡県")
            }
            Divider()
            Text("近畿")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "kyouto", title: "京都府")
                MenueButton(imageName: "osaka", title: "大阪府")
            }
            HStack {
                MenueButton(imageName: "hyougo", title: "兵庫県")
                MenueButton(imageName: "nara", title: "奈良県")
            }
            HStack {
                MenueButton(imageName: "shiga", title: "滋賀県")
                MenueButton(imageName: "wakayama", title: "和歌山県")
            }
            Divider()
            Text("中国")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "tottori", title: "鳥取県")
                MenueButton(imageName: "shimane", title: "島根県")
            }
            HStack {
                MenueButton(imageName: "okayama", title: "岡山県")
                MenueButton(imageName: "hiroshima", title: "広島県")
            }
            Divider()
            Text("四国")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "kagawa", title: "香川県")
                MenueButton(imageName: "ehime", title: "愛媛県")
            }
            HStack {
                MenueButton(imageName: "tokushima", title: "徳島県")
                MenueButton(imageName: "kouchi", title: "高知県")
            }
            Divider()
            Text("九州")
                .font(.title)
                .bold()
                .padding(.top)
            HStack {
                MenueButton(imageName: "yamaguchi", title: "山口県")
                MenueButton(imageName: "fukuoka", title: "福岡県")
            }
            HStack {
                MenueButton(imageName: "ooita", title: "大分県")
                MenueButton(imageName: "saga", title: "佐賀県")
            }
            HStack {
                MenueButton(imageName: "nagasaki", title: "長崎県")
                MenueButton(imageName: "kumamoto", title: "熊本県")
            }
            HStack {
                MenueButton(imageName: "miyazaki", title: "宮崎県")
                MenueButton(imageName: "kagoshima", title: "鹿児島県")
            }
            Divider()
            Text("沖縄")
                .font(.title)
                .bold()
                .padding(.top)
            MenueButton(imageName: "okinawa", title: "沖縄県")

        }
    }
    
    struct MenueButton: View {
        let imageName: String
        let title: String
        var body: some View {
            Button {
                
            } label: {
                HStack{
                    Image(imageName)
                        .resizable()
                        .frame(width: imageName=="hokkaidou" ? 70 : 50, height: 50)
                    Text(title)
                        .font(.title2)
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

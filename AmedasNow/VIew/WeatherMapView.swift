import SwiftUI
import PDFKit

struct WeatherMapView: View {

    var weatherMapData = WeatherMapData()
    var tanki: URL = URL(string: "https://www.data.jma.go.jp/fcd/yoho/data/jishin/kaisetsu_tanki_latest.pdf")!
    var syukan: URL = URL(string: "https://www.data.jma.go.jp/fcd/yoho/data/jishin/kaisetsu_shukan_latest.pdf")!

    var body: some View {
        VStack(alignment: .center){
            HeaderView
            ScrollView {
                HStack {
                    Text("日本周辺域天気図")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    Text("実況天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.nearNow)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack{
                    Text("24時間後予想天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.nearFt24)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack{
                    Text("48時間後予想天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.nearFt48)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack {
                    Text("アジア太平洋域天気図")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
                HStack{
                    Text("実況天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.asiaNow)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack{
                    Text("24時間後予想天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.asiaFt24)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack{
                    Text("48時間後予想天気図")
                        .font(.title3)
                        .padding(.horizontal)
                    Spacer()
                }
                AsyncImage(url: URL(string: weatherMapData.asiaFt48)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                }
                Divider()
                HStack {
                    Text("短期予報解説資料")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
                PDFViewUI(url: tanki)
                    .frame(height: 550)
                Divider()
                HStack {
                    Text("週間天気予報解説資料")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                }
                PDFViewUI(url: syukan)
                    .frame(height: 550)
                Divider()


            }
        }.onAppear(){
            weatherMapData.serchData()
        }
    }
}

struct PDFViewUI: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update needed
    }
}

extension WeatherMapView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "photo")
            Text("天気図")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
}

#Preview {
    WeatherMapView()
}

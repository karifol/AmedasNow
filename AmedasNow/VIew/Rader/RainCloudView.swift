import SwiftUI
import MapKit

struct RainCloudView: View {
    
    @State private var content: Int = 0

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MenueView.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                if (content == 0) {
                    RaderView()
                } else if (content == 1){
                    ThunderNccView()
                }
            }
        }

    }
}

extension RainCloudView {
    // メニュー
    private var MenueView: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Button{
                        content = 0
                    } label: {
                        Text("降水ナウキャスト")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 0 ? .blue: .white)
                            .background(content == 0 ? .white: .blue)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    .padding(3)
                    Button{
                        content = 1
                    } label: {
                        Text("雷ナウキャスト")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 1 ? .yellow: .white)
                            .background(content == 1 ? .white: .yellow)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    Button{
                        content = 2
                    } label: {
                        Text("竜巻発生確度ナウキャスト")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 2 ? .green: .white)
                            .background(content == 2 ? .white: .green)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                }
                
                
            }
            .padding(.vertical)
            .background(.gray.opacity(0.01))
            .padding(.top, 50)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import MapKit

struct PrecAnalisysView: View {
    
    @State private var content: Int = 0

    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MenueView.zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                if (content == 0) {
                    PrecAnalisys1hView()
                } else if (content == 1){
                    PrecAnalisys3hView()
                } else if (content == 2){
                    PrecAnalisys24hView()
                }
            }
        }

    }
}

extension PrecAnalisysView {
    // メニュー
    private var MenueView: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Button{
                        content = 0
                    } label: {
                        Text("1時間降水量")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 0 ? .precAnalysis: .white)
                            .background(content == 0 ? .white: .precAnalysis)
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
                        Text("3時間降水量")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 1 ? .precAnalysis: .white)
                            .background(content == 1 ? .white: .precAnalysis)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white, lineWidth: 2)
                            )
                    }
                    Button{
                        content = 2
                    } label: {
                        Text("24時間降水量")
                            .padding(5)
                            .padding(.horizontal)
                            .bold()
                            .foregroundColor(content == 2 ? .precAnalysis: .white)
                            .background(content == 2 ? .white: .precAnalysis)
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

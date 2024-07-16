import SwiftUI
import MapKit

struct MultiMapView: View {
    
    @State private var selectedItem: Int = 0
    
    var body: some View {
        VStack (spacing: 0){
            HeaderView
            ZStack {
                // 選択されたMap
                if selectedItem == 0 {
                    RaderView()
                } else {
                    SatelliteView()
                }
                // 上部メニューバー
                VStack {
//                    ScrollView(.horizontal){
                    
                    ScrollView(.horizontal){
                        HStack{
                            Button {
                                selectedItem = 0
                                print(selectedItem)
                            } label: {
                                Text("雨雲レーダー")
                                    .padding(5)
                                    .background(.white)
                                
                            }
                            .padding(.horizontal)
                            Button {
                                selectedItem = 1
                                print(selectedItem)
                            } label: {
                                Text("衛星")
                                    .padding(5)
                                    .background(.white)
                            }
                            .padding(.horizontal)
                            .zIndex(5)
                        }
                    }
                    .padding()
                    // 透明灰色
                    .background(.gray.opacity(0.1))
                    Spacer()
                }
            }
        }
    }
}

extension MultiMapView {
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "cloud.heavyrain")
            Text("レーダー")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
}

#Preview {
    MultiMapView()
}

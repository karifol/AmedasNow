//
//  SatelliteView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/07/16.
//

import SwiftUI
import MapKit

struct SatelliteView: View {
    
    @State private var validTimeString: String = ""
    var satelliteData = SatelliteData()
    init(){
        satelliteData.serchRank()
    }

    // タイムスライダー
    @State private var timeSliderValue: Double = 863
    
    // レーダータイル画像
    @State private var overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/20240716101730/jp/20240716101730/REP/ETC/{z}/{x}/{y}.jpg")
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            ZStack {
                MapView // Map
                TimeSliderView // タイムスライダー
            }
        }
        .onChange(of: satelliteData.validTimeList) { oldState, newState in
            validTimeString = validTimePlus9(validTime: satelliteData.validTimeList[0])
            let validTime = satelliteData.validTimeList[0] // 20240713065000
            print(validTime)
            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/\(validTime)/jp/\(validTime)/REP/ETC/{z}/{x}/{y}.jpg")
            validTimeString = validTimePlus9(validTime: validTime)
        }
    }
}

extension SatelliteView {
    
    // 20240713065000に9時間足す関数
    func validTimePlus9(validTime: String) -> String {
        let year = validTime.prefix(4)
        let month = validTime.prefix(6).suffix(2)
        let day = validTime.prefix(8).suffix(2)
        let hour = validTime.prefix(10).suffix(2)
        let minute = validTime.prefix(12).suffix(2)
        let validCalender = Calendar.current.date(from: DateComponents(year: Int(year)!, month: Int(month)!, day: Int(day)!, hour: Int(hour)!, minute: Int(minute)!, second: 0))!
        let validTimePlus9 = validCalender.addingTimeInterval(60*60*18)
        let validTimePlus9String = validTimePlus9.description
        let day9 = validTimePlus9String.prefix(10).suffix(2)
        let hour9 = validTimePlus9String.prefix(13).suffix(2)
        let minute9 = validTimePlus9String.prefix(16).suffix(2)
        return "\(day9)日\(hour9)時\(minute9)分"
    }
    
    // Map
    private var MapView: some View {
        VStack {
            KokudoMapView(overlay: overlay)
                .statusBar(hidden: false)
        }
    }
    
    // タイムスライダー
    private var TimeSliderView: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    Text(validTimeString)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top)
                    Slider(value: $timeSliderValue, in: 0...863, step: 1)
                        .padding(.horizontal)
                        .frame(width: 300, height: 40)
                        // 変わったら表示
                        .onChange(of: timeSliderValue) { oldState, newState in
                            let time = 863 - Int(newState)
                            let validTime = satelliteData.validTimeList[time] // 20240713065000
                            overlay = MKTileOverlay(urlTemplate: "https://www.jma.go.jp/bosai/himawari/data/satimg/\(validTime)/jp/\(validTime)/REP/ETC/{z}/{x}/{y}.jpg")
                            validTimeString = validTimePlus9(validTime: validTime)
                        }
                        .onAppear(){
                            satelliteData.serchRank()
                        }
                }
                .background(.ultraThinMaterial)
            }
            .padding()
        }
    }

}

#Preview {
    ContentView()
}

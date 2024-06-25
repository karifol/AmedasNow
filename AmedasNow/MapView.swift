//
//  MapView.swift
//  AmedasNow
//
//  Created by 堀ノ内海斗 on 2024/06/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    // 地点テーブル
    var amedasTableDataList = AmedasTableData()
    @State private var amedasTableData: AmedasTableItem? = nil
    init(){
        amedasTableDataList.serchAmedasTable()
    }
    
    // 気温のpicker
    @State private var selectedElement = "temp"
    private let elementList = [["風速", "wind"], ["気温", "temp"], ["降水量", "prec1h"]]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HeaderView
            ZStack {
                Map(){
                    ForEach(amedasTableDataList.amedasList) { amedas in
                        let targetCoordinate = CLLocationCoordinate2D(
                            latitude: amedas.lat,
                            longitude: amedas.lon
                        )
                        if (amedas.type == "A") {
                            Annotation(amedas.name, coordinate: targetCoordinate, anchor: .center) {
                                VStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 10, height: 10)
                                }
                                .padding()
                                .foregroundColor(.blue)
                            }
                        }
                    }
                }
                VStack(alignment: .leading){
                    // picker
                    ElementPickerView
                        .offset(y: 10)
                    Spacer()
                    // legend
                    if selectedElement == "temp" {
                        LegendTempView
                            .offset(x: 10, y: -50)
                    } else if selectedElement == "wind" {
                        LegendWindView
                            .offset(x: 10, y: -50)
                    } else if selectedElement == "prec1h" {
                        LegendPrecView
                            .offset(x: 10, y: -50)
                    }
                    // タイムスライダー
                    TimesliderView
                        .offset(y: -50)
                }
            }
        }
        
    }
}

extension MapView {
    
    // header
    private var HeaderView: some View {
        HStack {
            Image(systemName: "map")
            Text("マップ")
        }
        .foregroundStyle(.white)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .fontWeight(.bold)
    }
    
    // timeslider
    private var TimesliderView: some View {
        HStack {
            Button{
                
            } label: {
                Image(systemName: "lessthan")
            }
            
            Text("12:00")
            Button{
                
            } label: {
                Image(systemName: "greaterthan")
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding(.vertical, 10)
        .background(.black.opacity(0.5))
        .foregroundColor(.white)
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
    
    // legend temperature
    private var LegendTempView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("気温[℃]")
                .font(.footnote)
            LegendRowView(label: "35 ~   ", color: Color.temp35)
            LegendRowView(label: "30 ~ 34", color: Color.temp30)
            LegendRowView(label: "25 ~ 29", color: Color.temp25)
            LegendRowView(label: "20 ~ 24", color: Color.temp20)
            LegendRowView(label: "15 ~ 19", color: Color.temp15)
            LegendRowView(label: "10 ~ 14", color: Color.temp10)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp5)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp0)
            LegendRowView(label: "-5 ~ -1", color: Color.temp_5)
            LegendRowView(label: "   ~ -6", color: Color.temp_10)
        }
        .padding(10)
        .background(.white)
    }
    
    // legend wind
    private var LegendWindView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("風速[m/s]")
                .font(.footnote)
            LegendRowView(label: "25 ~   ", color: Color.temp35)
            LegendRowView(label: "20 ~ 24", color: Color.temp30)
            LegendRowView(label: "15 ~ 19", color: Color.temp25)
            LegendRowView(label: "10 ~ 14", color: Color.temp15)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp_10)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp10)
        }
        .padding(10)
        .background(.white)
    }
    
    // legend prec
    private var LegendPrecView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("前1時間")
                .font(.footnote)
            Text("降水量[mm/h]")
                .font(.footnote)
            LegendRowView(label: "25 ~   ", color: Color.temp35)
            LegendRowView(label: "20 ~ 24", color: Color.temp30)
            LegendRowView(label: "15 ~ 19", color: Color.temp25)
            LegendRowView(label: "10 ~ 14", color: Color.temp15)
            LegendRowView(label: " 5 ~ 9 ", color: Color.temp_10)
            LegendRowView(label: " 0 ~ 4 ", color: Color.temp10)
        }
        .padding(10)
        .background(.white)
    }


    
    // legend row
    struct LegendRowView: View {
        let label: String
        let color: Color
        var body: some View {
            HStack() {
                Circle()
                    .frame(width: 10)
                    .foregroundColor(color)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                Text(label)
                    .font(.footnote)
            }
        }
    }
    
    // picker
    private var ElementPickerView: some View {
        Picker("Options", selection: $selectedElement) {
            ForEach(elementList, id: \.self) { row in
                Text(row[0]).tag(row[1])
            }
        }
        .background(.blue.opacity(0.5))
        .padding(.horizontal, 10)
        .pickerStyle(.palette)
    }
}

extension Color {
    // 気温
    static var temp35  = Color(red: 180 / 255, green: 0 / 255,   blue: 144)
    static var temp30  = Color(red: 255 / 255, green: 40 / 255,  blue: 0)
    static var temp25  = Color(red: 255 / 255, green: 153 / 255, blue: 0)
    static var temp20  = Color(red: 255 / 255, green: 245 / 255, blue: 0)
    static var temp15  = Color(red: 255 / 255, green: 255 / 255, blue: 150 / 255)
    static var temp10  = Color(red: 255 / 255, green: 255 / 255, blue: 240 / 255)
    static var temp5   = Color(red: 185 / 255, green: 235 / 255, blue: 255 / 255)
    static var temp0   = Color(red: 0,         green: 150 / 255, blue: 255 / 255)
    static var temp_5  = Color(red: 0,         green: 65 / 255,  blue: 255 / 255)
    static var temp_10 = Color(red: 0,         green: 32 / 255,  blue: 128 / 255)
}

#Preview {
    ContentView()
}

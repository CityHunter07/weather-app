//
//  ForcastView.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 21/10/23.
//

import SwiftUI

struct ForecastView: View {
    @State var selection: Int = 0
    var bottomSheetTranslationProtrayed: CGFloat = 1
    var threeHourlyData: ThreeHourlyData?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SegmentedControl(selection: $selection)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if selection == 0 {
                            ForEach(threeHourlyData?.list.prefix(5) ?? [List(dt_txt: "2022-08-30 15:00:00", pop: 0.3, main: MainData(temp_max: 296, temp_min: 296, temp: 296))]) { list in
                                ForecastCard(list: list, forecastPeriod: ForecastPeriod.hourly)
                            }
                            .transition(.offset(x: -430))
                        }
                        else {
                            ForEach(threeHourlyData?.list.prefix(5) ?? [List(dt_txt: "2022-08-30 15:00:00", pop: 0.3, main: MainData(temp_max: 296, temp_min: 296, temp: 296))]) { list in
                                ForecastCard(list: list, forecastPeriod: ForecastPeriod.weekly)
                            }
                            .transition(.offset(x: 430))
                        }
                    }
                    
                    Image("Forecast Widgets")
                        .opacity(bottomSheetTranslationProtrayed)
                }
                .padding(.horizontal, 20)
            }
        }
        //        .background(Blur(radius: 25, opaque: true))         // using this instead of  .background(.ultraThinMaterial)
        //        .background(.ultraThinMaterial)
        .backgroundBlur(radius: 25, opaque: false)           // custom extension for giving blur
        .background(Color.bottomSheetBackground)
        
//        .background(
//            Color.background.opacity(0.9) // Adjust the background color and opacity as needed
//                .blur(radius: 2) // Adjust the blur radius as needed
////            in: Blur(radius: 2, opaque: false)
//        )
//        .background(Blur())
//        .edgesIgnoringSafeArea(.all)
        .clipShape(RoundedRectangle(cornerRadius: 44))          // used to give a shape to view and all effects are only visible in that shape
        .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1)
        .overlay {
            Divider()
                .blendMode(.overlay)
                .background(Color.bottomSheetBorderTop)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.3))
                .frame(width: 50, height: 5)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(threeHourlyData: ThreeHourlyData(list: [List(dt_txt: "2022-08-30 15:00:00", pop: 0.3, main: MainData(temp_max: 296, temp_min: 296, temp: 296))]))
            .preferredColorScheme(.dark)
    }
}

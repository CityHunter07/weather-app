//
//  HomeView.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 15/10/23.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385
}

struct HomeView: View {
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @StateObject var weatherDataGetter = WeatherDataGetter()
//    @ObservedObject var viewModel = WeatherDataGetter()
    
    // creating a computed property
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    private var attributedString: AttributedString {
        let temp = "\((Int(weatherDataGetter.localWeatherForecastData?.main.temparature ?? 0)).description)º"
        var string = AttributedString(temp + (hasDragged ? " | " : "\n ") + "Mostly Clear")
        
        if let temparature = string.range(of: temp) {
            string[temparature].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
            string[temparature].foregroundColor = hasDragged ? .secondary : .primary
        }
        
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary
        }
        
        if let info = string.range(of: "Mostly Clear") {
            string[info].font = .title3.weight(.semibold)
            string[info].foregroundColor = .secondary 
        }
        
        return string
   }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom          // screen full height + top area near notch + bottom area near curve
                
                let imageOffset = screenHeight + 36
                
                ZStack {
                    // BackGround color
                    Color.background
                        .ignoresSafeArea()
                    
                    // Background image
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // House image
                    Image("House")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 257)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // Temparture details
                    VStack {
                        
                        Text(weatherDataGetter.localWeatherForecastData?.name ?? "new")
                            .font(.largeTitle)
                        
                        VStack {
                            Text(attributedString)
                            
                            Text("H:\(((weatherDataGetter.localWeatherForecastData?.main.max_temparature ?? 0)).rounded().description)º   L:\(((weatherDataGetter.localWeatherForecastData?.main.min_temparature ?? 0)).rounded().description)º")
                                .font(.title3.weight(.semibold))
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 51)
                    
                    BottomSheetView(position: $bottomSheetPosition) {
//                        Text(bottomSheetTranslationProrated.formatted())
                    }
                    content: {
                        // need to send the data required to forecast view
                        // call three hour data -> parse the Time hours from now() and 6 next places
                        
                        ForecastView(bottomSheetTranslationProtrayed: bottomSheetTranslationProrated, threeHourlyData: weatherDataGetter.threeHourlyData)
                        
                        
                    }
                    .onBottomSheetDrag { translation in
                        bottomSheetTranslation = translation / screenHeight
                        withAnimation {
                            if bottomSheetPosition == BottomSheetPosition.top {
                                hasDragged = true
                            }
                            else {
                                hasDragged = false
                            }
                        }
                    }
                        
                    // fore ground
                    BottomTabBar(action: {
                        bottomSheetPosition = .top
                    })
                    .offset(x: 0, y: bottomSheetTranslationProrated * 115)
                    .environmentObject(weatherDataGetter)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(weatherDataGetter: WeatherDataGetter())
            .preferredColorScheme(.dark)
    }
}




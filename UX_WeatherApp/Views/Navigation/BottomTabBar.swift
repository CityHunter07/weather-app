//
//  BottomTabBar.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 15/10/23.
//

import SwiftUI

struct BottomTabBar: View {
    @EnvironmentObject var weatherDataGetter: WeatherDataGetter
    var action: () -> Void
    var body: some View {
        ZStack(alignment: .bottom) {
            Arc()
                .fill(Color.bottomSheetBackground)
                .frame(height: 88)
                .overlay {
                    Arc()
                        .stroke(Color.tabBarBorder, lineWidth: 2)
                }

            HStack {
                Button {
                    action()
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                NavigationLink {
                    WeatherView(displayingCities: weatherDataGetter.searchHistoryData)                    
                } label: {
                    Image(systemName: "list.star")
                        .frame(width: 44, height: 44)
                }
                .onTapGesture {
                    getPreviousSearchesWeatherData()
                }
                
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 20, leading: 32, bottom: 24, trailing: 32))
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
    
    func getPreviousSearchesWeatherData() {
        weatherDataGetter.getPreviousSearchesWeatherData()
    }
    
}

struct BottomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabBar(action: {})
            .preferredColorScheme(.dark)
            .environmentObject(WeatherDataGetter())
    }
}

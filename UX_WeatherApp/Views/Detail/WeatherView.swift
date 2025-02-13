//
//  WeatherView.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 22/10/23.
//

import SwiftUI

struct WeatherView: View {
    @State private var searchText = ""
    @EnvironmentObject var weatherDataGetter: WeatherDataGetter
    @State var displayingCities: [WeatherDetails]
    
    
    
    var searchResults: [Forecast] {
        if searchText.isEmpty {
            return Forecast.cities
        }
        else {
            return Forecast.cities.filter { $0.location.contains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(displayingCities) { cityData in
                        WeatherWidget(WeatherDetails: cityData)
                    }
                    
                }
            }
            .safeAreaInset(edge: .top) {
                Color.clear
                    .frame(height: 110)
                
//                EmptyView()                       // both works the same
//                    .frame(height: 110)
            }
        }
        .overlay {
            NavigationBar(searchText: $searchText)
        }
        .toolbar(.hidden, for: .navigationBar)
//        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for city")
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherView(displayingCities: [])
        }
    }
}

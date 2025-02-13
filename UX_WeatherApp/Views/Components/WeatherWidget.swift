//
//  WeatherWidget.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 22/10/23.
//

import SwiftUI

struct WeatherWidget: View {
//    var forecast: Forecast?
    var WeatherDetails: WeatherDetails
    var body: some View {
        ZStack {
            Trapezoid()
                .fill(Color.weatherWidgetBackground)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Int(WeatherDetails.main.temparature))º")
                        .font(.system(size: 64))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("H : \(Int(WeatherDetails.main.max_temparature)) | L : \(Int(WeatherDetails.main.min_temparature))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text("\(WeatherDetails.name)")
                            .font(.body)
                            .lineLimit(1)
                    }
                    
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Image("Moon cloud fast wind large")
                    
//                    Text("\(forecast?.weather.rawValue)")
//                        .font(.footnote)
                }
            }
            .foregroundColor(.white)
            .padding(.leading, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 342, height: 184, alignment: .bottom)
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidget(WeatherDetails: WeatherDetails(id: 11111, dt: 11111, name: "Hydrabad", main: MainData(temp_max: 301, temp_min: 299, temp: 300), sys: SunData(country: "India", sunrise: 5443, sunset: 54623434), coord: Coordinates(lon: 22.333, lat: 34.452)))
            .preferredColorScheme(.dark)
    }
}

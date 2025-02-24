//
//  ForecastCard.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 22/10/23.
//

import SwiftUI

struct ForecastCard: View {
    var list: List
    var forecastPeriod: ForecastPeriod
    var isActive: Bool {
        if forecastPeriod == ForecastPeriod.hourly {
            let isThisHour = Calendar.current.isDate(.now, equalTo: list.date, toGranularity: .hour)
            return isThisHour
        }
        else {
            let isToday = Calendar.current.isDate(.now, equalTo: list.date, toGranularity: .day)
            return isToday
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.forecastCardBackground.opacity(isActive ? 1 : 0.2))
                .frame(width: 60, height: 146)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
                    
                }
                .innerShadow(shape: RoundedRectangle(cornerRadius: 30), color: .white.opacity(0.25), lineWidth: 1, offsetX: 1, offsetY: 1, blur: 0, blendMode: .overlay)
            
            VStack(spacing: 16) {
                Text(list.date, format: forecastPeriod == ForecastPeriod.hourly ? .dateTime.hour() : .dateTime.weekday())
                    .font(.subheadline.weight(.semibold))
                
                VStack(spacing: -4) {
//                    Image("\(forecast.icon) small")
                    Image("Moon cloud fast wind small")
                    Text(list.pop, format: .percent)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(Color.white)
                        .opacity(list.pop > 0 ? 1 : 0)
                }
                .frame(height: 42)
                
                Text("\(Int(list.main.temparature))º")
                    .font(.title3)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .frame(width: 60, height: 146)
        }
    }
}

struct ForecastCard_Previews: PreviewProvider {
    static var previews: some View {
        ForecastCard(list: List(dt_txt: "2022-08-30 15:00:00", pop: 0.3, main: MainData(temp_max: 296, temp_min: 296, temp: 296)), forecastPeriod: ForecastPeriod.hourly)
//            .preferredColorScheme(.dark)
    }
}


//struct ForecastCard: View {
//    var forecast: Forecast
//    var forecastPeriod: ForecastPeriod
//    var isActive: Bool {
//        if forecastPeriod == ForecastPeriod.hourly {
//            let isThisHour = Calendar.current.isDate(.now, equalTo: forecast.date, toGranularity: .hour)
//            return isThisHour
//        }
//        else {
//            let isToday = Calendar.current.isDate(.now, equalTo: forecast.date, toGranularity: .day)
//            return isToday
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 30)
//                .fill(Color.forecastCardBackground.opacity(isActive ? 1 : 0.2))
//                .frame(width: 60, height: 146)
//                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 4)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 30)
//                        .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
//
//                }
//                .innerShadow(shape: RoundedRectangle(cornerRadius: 30), color: .white.opacity(0.25), lineWidth: 1, offsetX: 1, offsetY: 1, blur: 0, blendMode: .overlay)
//
//            VStack(spacing: 16) {
//                Text(forecast.date, format: forecastPeriod == ForecastPeriod.hourly ? .dateTime.hour() : .dateTime.weekday())
//                    .font(.subheadline.weight(.semibold))
//
//                VStack(spacing: -4) {
//                    Image("\(forecast.icon) small")
//                    Text(forecast.probability, format: .percent)
//                        .font(.footnote.weight(.semibold))
//                        .foregroundColor(Color.probabilityText)
//                        .opacity(forecast.probability > 0 ? 1 : 0)
//                }
//                .frame(height: 42)
//
//                Text("\(forecast.temperature)º")
//                    .font(.title3)
//            }
//            .padding(.horizontal, 8)
//            .padding(.vertical, 16)
//            .frame(width: 60, height: 146)
//        }
//    }
//}

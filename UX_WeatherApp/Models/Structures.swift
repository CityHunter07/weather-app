import Foundation

struct WeatherDetails: Codable, Identifiable {
    var id: Int
    var dt: Int
    var name: String
    var main: MainData
    var sys: SunData
    var coord: Coordinates
}

struct MainData: Codable {
    var temp_max: Double
    var temp_min: Double
    var temp: Double
    
    var max_temparature: Double {
        return temp_max - 273.15
    }
    var min_temparature: Double {
        return temp_min - 273.15
    }
    var temparature: Double {
        return temp - 273.15
    }
}

struct SunData: Codable {
    var country: String
    var sunrise: Int
    var sunset: Int
}

struct Coordinates: Codable {
    var lon: Double
    var lat: Double
}

struct List: Codable, Identifiable {
    let id = UUID()
    
    var dt_txt: String
    var pop: Double // probability
    var main: MainData
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dt_txt)!
    }
}

struct ThreeHourlyData: Codable {
    var list: [List]
}


enum APIError: Error {
    case invalidURL
    case requestFailed
}

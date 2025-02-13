//
//  WeatherDataGetter.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 29/11/23.
//

import Foundation
import Combine

class WeatherDataGetter: ObservableObject {
    @Published var localWeatherForecastData: WeatherDetails?
    @Published var fivedayData: [WeatherDetails] = [] // need to retrive
    @Published var threeHourlyData: ThreeHourlyData?
    @Published var searchHistoryData: [WeatherDetails] = []
    @Published var apiCallingProgress: Int = 10
    
    init() {
        getCurrentCityWeather(completionHandler: { result in
            switch result {
            case .success( _):
                print("calling getThreeHourlyData after geting current local weather data")
                self.apiCallingProgress = 30
                self.getThreeHourlyData()
//                self.getFiveDayData()
            case .failure( _):
                print("Failed to connect to internet")
                self.apiCallingProgress = 100
            }
        })
        getPreviousSearchesWeatherData()
//        getThreeHourlyData()
    }
    
    func callApi(urlString: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        print("Calling API with URL: \(urlString)")
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Hyderabad&appid=ab576d4694b25e458d5e189e5a57e500"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completionHandler(.failure(APIError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completionHandler(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response during api call: \n\(String(describing: response))")
                completionHandler(.failure(APIError.requestFailed))
                return
            }
            guard let data = data else {
                print("No data received")
                completionHandler(.failure(APIError.requestFailed))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
    
    func getCurrentCityWeather(completionHandler: @escaping (Result<String, Error>) -> ()) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Hyderabad&appid=ab576d4694b25e458d5e189e5a57e500"
        callApi(urlString: urlString, completionHandler: { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    var decodedData = try decoder.decode(WeatherDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.localWeatherForecastData = decodedData
                        print("localWeatherData: \(self.localWeatherForecastData?.coord.lat)")
                        completionHandler(.success("success"))
                    }
                }
                catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            case .failure(let error) :
                print("Error calling API: \(error)")
                completionHandler(.failure(APIError.requestFailed))
            }
        })
    }
    
    func getWeather(of city: String) {
        print("getWeather of city: \(city)")
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=ab576d4694b25e458d5e189e5a57e500"
        callApi(urlString: urlString, completionHandler: {result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    var decodedData = try decoder.decode(WeatherDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.searchHistoryData.append(decodedData)
                        self.apiCallingProgress = 60
                    }
                }
                catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
            }
        })
    }
 
    func getPreviousSearchesWeatherData() {
        print("Getting previous searches weather data")
        let searchHistoryManager = SearchHistoryManager()
        let searchedCities = searchHistoryManager.getSearchHistory()
        for city in searchedCities {
            getWeather(of: city)
        }
    }
    
    func getThreeHourlyData() {
        print("getting three hourly data from coordinates lat: \(String(describing: localWeatherForecastData?.coord.lat))")
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(String(describing: localWeatherForecastData?.coord.lat ?? 0))&lon=\(String(describing:localWeatherForecastData?.coord.lon ?? 0) )&appid=ab576d4694b25e458d5e189e5a57e500"
        callApi(urlString: urlString, completionHandler: { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    var decodedData = try decoder.decode(ThreeHourlyData.self, from: data)
                    DispatchQueue.main.async {
                        self.threeHourlyData = decodedData
//                        print("threeHoulrly data now: \(self.threeHourlyData)")
                    }
                }
                catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            case .failure(let error) :
                print("Error calling API: \(error)")
            }
        })
    }
    
    func getFiveDayData() {
        print("=========get five day data")
        let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(String(describing: localWeatherForecastData?.coord.lat ?? 0))&lon=\(String(describing:localWeatherForecastData?.coord.lon ?? 0) )&cnt=5&appid=ab576d4694b25e458d5e189e5a57e500"
        callApi(urlString: urlString, completionHandler: { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    var decodedData = try decoder.decode([WeatherDetails].self, from: data)
                    DispatchQueue.main.async {
                        self.fivedayData = decodedData
//                        print("threeHoulrly data now: \(self.threeHourlyData)")
                    }
                }
                catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            case .failure(let error) :
                print("Error calling API: \(error)")
            }
        })
    }

}

// https://api.openweathermap.org/data/2.5/forecast/daily?lat=17.3753&lon=78.4744&cnt=5&appid=ab576d4694b25e458d5e189e5a57e500

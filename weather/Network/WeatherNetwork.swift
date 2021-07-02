//
//  WeatherNetwork.swift
//  ApiTest
//
//  Created by Roman Alikevich on 16.03.2021.
//

import UIKit

class WeatherNetwork {
    var currentWeather: CurrentWeather?
    var dailyWeather: DailyWeather?
    var hourlyWeather: HourlyWeather?
    var url: URL?
    
    func weatherRequest(_ api: String, complition: @escaping(_ data: Data) -> ()) {
        if let url = URL(string: api) {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    complition(data)
                }
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
            }
            dataTask.resume()
        }
    }
    
    func createWeatherURLByCoordinate(latitude: Double, longitude: Double) {
        var urlComponents = URLComponents(string: ApiNetworkUrl.NETWORK_HTTP_URL.rawValue)!
        let queryItems = [URLQueryItem(name: "lat", value: String(latitude)),
                          URLQueryItem(name: "lon", value: String(longitude)),
                          URLQueryItem(name: "appid", value: "a48b233db79278ac59b174cd57b4d091"),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "lang", value: "ru")]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        self.url = url
    }
    
    func findWeatherByCoordinate(latitude: Double, longitude: Double, updatedTable: @escaping() -> ()) -> CurrentWeather? {
        createWeatherURLByCoordinate(latitude: latitude, longitude: longitude)
        if let url = url {
            weatherRequest(url.absoluteString) { (data) in
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    self.currentWeather = try! JSONDecoder().decode(CurrentWeather.self, from: data)
                    print("self.currentWeather \(self.currentWeather)")
                    DispatchQueue.main.async {
                        updatedTable()
                    }
                }
            }
        }
        return currentWeather
    }
    
    func createDailyWeatherURLByCity(city: String) {
        var urlComponents = URLComponents(string: ApiNetworkUrl.DAILY_FORECAST_NETWORK_HTTP_URL.rawValue)!
        let queryItems = [URLQueryItem(name: "q", value: city),
                          URLQueryItem(name: "cnt", value: String(8)),
                          URLQueryItem(name: "appid", value: "a48b233db79278ac59b174cd57b4d091"),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "lang", value: "ru")]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        self.url = url
    }
    
    func findDailyWeatherByCity(city: String, updatedTable: @escaping() -> ()) -> DailyWeather? {
        createDailyWeatherURLByCity(city: city)
        if let url = url {
            weatherRequest(url.absoluteString) { (data) in
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    self.dailyWeather = try! JSONDecoder().decode(DailyWeather.self, from: data)
                    print("self.dailyWeather \(self.dailyWeather?.list?.count)")
                    DispatchQueue.main.async {
                        updatedTable()
                    }
                }
            }
        }
        return dailyWeather
    }
    func createHourlyForecastURLByCoordinate(latitude: Double, longitude: Double) {
        
        var urlComponents = URLComponents(string: ApiNetworkUrl.HOURLY_FORECAST_NETWORK_HTTP_URL.rawValue)!
        let queryItems = [URLQueryItem(name: "lat", value: String(latitude)),
                          URLQueryItem(name: "lon", value: String(longitude)),
                          URLQueryItem(name: "appid", value: "a48b233db79278ac59b174cd57b4d091"),
                          URLQueryItem(name: "units", value: "metric"),
                          URLQueryItem(name: "lang", value: "ru")]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        self.url = url
    }
    
    func findHourlyForecastByCoordinate(latitude: Double, longitude: Double, updatedTable: @escaping() -> ()) -> HourlyWeather? {
        createHourlyForecastURLByCoordinate(latitude: latitude, longitude: longitude)
        if let url = url {
            weatherRequest(url.absoluteString) { (data) in
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    let obj = try! JSONDecoder().decode(HourlyWeather.self, from: data)
                    self.hourlyWeather = obj
                    print("self.hourlyWeather \(obj.hourly?.first?.dt)")
                    DispatchQueue.main.async {
                        updatedTable()
                    }
                }
            }
        }
        return hourlyWeather
    }
}

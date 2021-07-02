//
//  HourlyWeather.swift
//  weather
//
//  Created by Roman Alikevich on 08.05.2021.
//

import Foundation

class HourlyWeather: Codable {
    var hourly: [HourlyWeatherData]?
}

class HourlyWeatherData: Codable {
    var dt: Double?
    var temp: Double?
    var humidity: Double?
    var weather: [WeatherIcon]?
}

class WeatherIcon: Codable {
    var icon: String?
}

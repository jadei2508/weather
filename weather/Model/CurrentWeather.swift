//
//  CurrentWeather.swift
//  weather
//
//  Created by Roman Alikevich on 08.05.2021.
//

import Foundation

class CurrentWeather: Codable {
    var coord: Coord?
    var weather: [Weather]
    var main: Main?
    var wind: Wind?
    var dt: Int = 0
    var sys: Sys?
    var timezone: Int = 0
    var id: Int = 0
    var name: String = ""
}

// MARK: - Coord
class Coord: Codable {
   var lon: Double = 0.0
   var lat: Double = 0.0
}

// MARK: - Main
class Main: Codable {
    var temp: Double = 0.0
    var feelsLike: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
class Sys: Codable {
    var type: Int = 0
    var id: Int = 0
    var country: String = ""
    var sunrise: Int = 0
    var sunset: Int = 0
}

// MARK: - Weather
class Weather: Codable {
    var id: Int = 0
    var main: String = ""
    var weatherDescription: String = ""
    var icon: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
class Wind: Codable {
    var speed: Double = 0.0
    var deg: Int = 0
}

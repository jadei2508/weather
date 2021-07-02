//
//  DailyWeather.swift
//  weather
//
//  Created by Roman Alikevich on 08.05.2021.
//

import Foundation

class DailyWeather: Codable {
    var list: [WeatherArray]?
//    var city: City?
}

class WeatherArray: Codable {
    var dt: Int?
    var temp: Temperature?
    var weather: [Weathers]?
}

class Weathers: Codable {
    var icon: String?
}

class Temperature: Codable {
    var min: Double?
    var max: Double?
}

//// MARK: - Welcome
//struct DailyWeather: Codable {
//    let city: City
//    let cod: String
//    let message: Double
//    let cnt: Int
//    let list: [List]
//}
//
//// MARK: - City
//struct City: Codable {
//    let id: Int
//    let name: String
//    let coord: Coords
//    let country: String
//    let population, timezone: Int
//}
//
//// MARK: - Coord
//struct Coords: Codable {
//    let lon, lat: Double
//}
//
//// MARK: - List
//struct List: Codable {
//    let dt, sunrise, sunset: Int
//    let temp: Temp
//    let feelsLike: FeelsLike
//    let pressure, humidity: Int
//    let weather: [Weathers]
//    let speed: Double
//    let deg: Int
//    let gust: Double
//    let clouds: Int
//    let pop: Double
//    let rain: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, temp
//        case feelsLike = "feels_like"
//        case pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
//    }
//}
//
//// MARK: - FeelsLike
//struct FeelsLike: Codable {
//    let day, night, eve, morn: Double
//}
//
//// MARK: - Temp
//struct Temp: Codable {
//    let day, min, max, night: Double
//    let eve, morn: Double
//}
//
//// MARK: - Weather
//struct Weathers: Codable {
//    let id: Int
//    let main, weatherDescription, icon: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription = "description"
//        case icon
//    }
//}

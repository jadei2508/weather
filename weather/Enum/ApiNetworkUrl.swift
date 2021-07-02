//
//  ApiNetworkUrl.swift
//  weather
//
//  Created by Roman Alikevich on 13.05.2021.
//

import Foundation

enum ApiNetworkUrl: String {
    case NETWORK_HTTP_URL = "https://api.openweathermap.org/data/2.5/weather"
    case HOURLY_FORECAST_NETWORK_HTTP_URL = "https://api.openweathermap.org/data/2.5/onecall"
    case DAILY_FORECAST_NETWORK_HTTP_URL = "https://api.openweathermap.org/data/2.5/forecast/daily"
}

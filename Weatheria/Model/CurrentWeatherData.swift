//
//  WeatherData.swift
//  Weatheria
//
//  Created by Kharisma Putra on 08/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let timezone: Int
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
    let icon: String
}

struct Wind: Decodable {
    let speed: Double
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let sunrise: Date
    let sunset: Date
}

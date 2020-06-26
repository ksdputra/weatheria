//
//  HourlyForecastData.swift
//  Weatheria
//
//  Created by Kharisma Putra on 26/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct HourlyForecastData: Decodable {
    let timezone_offset: Int
    let hourly: [Hourly]
}

struct Hourly: Decodable {
    let temp: Double
    let dt: Int
    let weather: [Weather]
}

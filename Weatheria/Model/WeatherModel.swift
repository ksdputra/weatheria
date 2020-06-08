//
//  WeatherModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 08/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let city: String
    let temp: Double
    let description: String
    let feelsLikeTemp: Double
    let tempMin: Double
    let tempMax: Double
    let sunrise: Date
    let sunset: Date
    let wind: Double
    let humidity: Int
    let cloud: Int
    let pressure: Int
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }

    }
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    init(conditionID: Int, city: String, temp: Double, description: String, feelsLikeTemp: Double, tempMin: Double, tempMax: Double, sunrise: Date, sunset: Date, wind: Double, humidity: Int, cloud: Int, pressure: Int) {
        self.conditionID = conditionID
        self.city = city
        self.temp = temp
        self.description = description
        self.feelsLikeTemp = feelsLikeTemp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.sunrise = sunrise
        self.sunset = sunset
        self.wind = wind
        self.humidity = humidity
        self.cloud = cloud
        self.pressure = pressure
    }
}

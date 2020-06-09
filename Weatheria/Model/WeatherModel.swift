//
//  WeatherModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 08/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit

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
    let timeZone: Int
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
    
    var conditionColor: UIColor {
        switch conditionID {
        case 200...232:
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case 300...321:
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case 500...531:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 600...622:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case 701...781:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case 800:
            return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case 801...804:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        default:
            return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    init(conditionID: Int, city: String, temp: Double, description: String, feelsLikeTemp: Double, tempMin: Double, tempMax: Double, sunrise: Date, sunset: Date, wind: Double, humidity: Int, cloud: Int, pressure: Int, timeZone: Int) {
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
        self.timeZone = timeZone
    }
}

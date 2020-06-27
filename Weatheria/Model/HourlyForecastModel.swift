//
//  HourlyForecastModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 26/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit

struct HourlyForecastModel {
    let id: Int
    let temp: Double
    let dt: Int
    let timezone: Int
    let description: String
    
    var conditionColor: UIColor {
        switch id {
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
            return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case 801...804:
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        default:
            return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
    
    init(id: Int, temp: Double, dt: Int, timezone: Int, description: String) {
        self.id = id
        self.temp = temp
        self.dt = dt
        self.timezone = timezone
        self.description = description
    }
    
    func getHour() -> String {
        let formatter = DateFormatter()
        let timeInterval = Double(dt)
        formatter.dateFormat = "d MMM HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        let hour = formatter.string(from: Date(timeIntervalSince1970: timeInterval))
        return hour
    }
    
    func getTemp() -> String {
        return "\(temp)°C"
    }
}

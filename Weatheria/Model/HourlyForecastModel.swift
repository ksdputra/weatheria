//
//  HourlyForecastModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 26/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct HourlyForecastModel {
    let temp: Double
    let dt: Int
    let timezone: Int
    let description: String
    
    init(temp: Double, dt: Int, timezone: Int, description: String) {
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

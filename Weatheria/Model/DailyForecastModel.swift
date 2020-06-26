//
//  OneCallModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct DailyForecastModel {
    let day: Double
    let dt: Int
    let timezone: Int
    let description: String
    
    init(day: Double, dt: Int, timezone: Int, description: String) {
        self.day = day
        self.dt = dt
        self.timezone = timezone
        self.description = description
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        let timeInterval = Double(dt)
        formatter.dateFormat = "d MMM"
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        let date = formatter.string(from: Date(timeIntervalSince1970: timeInterval))
        return date
    }
    
    func getTemp() -> String {
        let temp = "\(day)°C"
        return temp
    }
}

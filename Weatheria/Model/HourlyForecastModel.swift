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
    let description: String
    
    init(temp: Double, dt: Int, description: String) {
        self.temp = temp
        self.dt = dt
        self.description = description
    }
    
    func getHour() -> String {
        let format = DateFormatter()
        let timeInterval = Double(dt)
        format.dateFormat = "HH:mm"
        let hour = format.string(from: Date(timeIntervalSince1970: timeInterval))
        return hour
    }
    
    func getTemp() -> String {
        return "\(temp)°C"
    }
}

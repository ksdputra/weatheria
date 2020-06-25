//
//  OneCallModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct OneCallModel {
    let day: Double
    let dt: Int
    
    init(day: Double, dt: Int) {
        self.day = day
        self.dt = dt
    }
    
    func getDate() -> String {
        let format = DateFormatter()
        let timeInterval = Double(dt)
        format.dateFormat = "d MMM"
        let date = format.string(from: Date(timeIntervalSince1970: timeInterval))
        return date
    }
    
    func getTemp() -> String {
        let temp = "\(day)°C"
        return temp
    }
}
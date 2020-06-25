//
//  OneCallModel.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct OneCallModel {
    let days: [Double]
    let dts: [Int]
    
    init(days: [Double], dts: [Int]) {
        self.days = days
        self.dts = dts
    }
    
    func getDate() -> [String] {
        let format = DateFormatter()
        var dates: [String] = []
        for dt in dts {
            let timeInterval = Double(dt)
            format.dateFormat = "d MMM"
            let date = format.string(from: Date(timeIntervalSince1970: timeInterval))
            dates.append(date)
        }
        return dates
    }
    
    func getTemps() -> [String] {
        var temps: [String] = []
        for day in days {
            let temp = "\(day)°C"
            temps.append(temp)
        }
        return temps
    }
}

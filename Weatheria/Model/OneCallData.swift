//
//  OneCallMode.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation

struct OneCallData: Decodable {
    let daily: [Daily]
}

struct Daily: Decodable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Decodable {
    let day: Double
}

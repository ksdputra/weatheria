//
//  ForecastManager.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation
import CoreLocation

protocol DailyForecastManagerDelegate {
    func didUpdateForecast(forecasts: [DailyForecastModel])
}

struct DailyForecastManager {
    let url = "http://api.openweathermap.org/data/2.5/onecall?appid=e72ca729af228beabd5d20e3b7749713&units=metric&exclude=current,minutely,hourly"
    var delegate: DailyForecastManagerDelegate?
    
    mutating func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            task.resume()
        } else {
            print("error")
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            if let forecasts = parseJSON(oneCallData: safeData) {
                DispatchQueue.main.async {
                    self.delegate?.didUpdateForecast(forecasts: forecasts)
                }
            } else {
                DispatchQueue.main.async {
                    print("error")
                }
            }
        }
    }
    
    func parseJSON(oneCallData: Data) -> [DailyForecastModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DailyForecastData.self, from: oneCallData)
            var oneCallModels: [DailyForecastModel] = []
            for daily in decodedData.daily {
                let id = daily.weather[0].id
                let day = daily.temp.day
                let dt = daily.dt
                let timezone = decodedData.timezone_offset
                let description = daily.weather[0].description
                let oneCallModel = DailyForecastModel(id: id, day: day, dt: dt, timezone: timezone, description: description)
                oneCallModels.append(oneCallModel)
            }
            return oneCallModels
        } catch {
            print(error)
            return nil
        }
    }
}

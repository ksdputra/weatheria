//
//  ForecastManager.swift
//  Weatheria
//
//  Created by Kharisma Putra on 24/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastManagerDelegate {
    func didUpdateForecast(forecast: OneCallModel)
}

struct ForecastManager {
    let url = "http://api.openweathermap.org/data/2.5/onecall?appid=e72ca729af228beabd5d20e3b7749713&units=metric&exclude=current,minutely,hourly"
    var delegate: ForecastManagerDelegate?
    
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
//            self.delegate?.didNotFindWeather()
            print("error")
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            if let forecast = parseJSON(oneCallData: safeData) {
                DispatchQueue.main.async {
//                    self.delegate?.stopSpinning()
                    self.delegate?.didUpdateForecast(forecast: forecast)
                }
            } else {
                DispatchQueue.main.async {
//                    self.delegate?.stopSpinning()
//                    self.delegate?.didNotFindWeather()
                    print("error")
                }
            }
        }
    }
    
    func parseJSON(oneCallData: Data) -> OneCallModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(OneCallData.self, from: oneCallData)
            var days: [Double] = []
            var dts: [Int] = []
            for daily in decodedData.daily {
                let day = daily.temp.day
                let dt = daily.dt
                dts.append(dt)
                days.append(day)
            }
//            let conditionID = decodedData.weather[0].id
//            let city = decodedData.name
//            let temp = decodedData.main.temp
//            let icon = decodedData.weather[0].icon
//            let description = decodedData.weather[0].description
//            let feelsLikeTemp = decodedData.main.feels_like
//            let tempMin = decodedData.main.temp_min
//            let tempMax = decodedData.main.temp_max
//            let sunrise = decodedData.sys.sunrise
//            let sunset = decodedData.sys.sunset
//            let wind = decodedData.wind.speed
//            let humidity = decodedData.main.humidity
//            let clouds = decodedData.clouds.all
//            let pressure = decodedData.main.pressure
//            let timeZone = decodedData.timezone
//            let weather = WeatherModel(conditionID: conditionID, city: city, temp: temp, icon: icon, description: description, feelsLikeTemp: feelsLikeTemp, tempMin: tempMin, tempMax: tempMax, sunrise: sunrise, sunset: sunset, wind: wind, humidity: humidity, clouds: clouds, pressure: pressure, timeZone: timeZone)
//            return weather
            print(dts)
            print(days)
            return OneCallModel(days: days, dts: dts)
        } catch {
            print(error)
            return nil
        }
    }
}

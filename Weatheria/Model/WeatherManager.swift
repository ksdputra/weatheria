//
//  WeatherManager.swift
//  Weatheria
//
//  Created by Kharisma Putra on 08/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didNotFindWeather()
    func startSpinning()
    func stopSpinning()
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=e72ca729af228beabd5d20e3b7749713&units=metric"
    var delegate: WeatherManagerDelegate?
    
    mutating func fetchWeather(of cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    mutating func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            if let weather = parseJSON(weatherData: safeData) {
                DispatchQueue.main.async {
                    self.delegate?.stopSpinning()
                    self.delegate?.didUpdateWeather(weather: weather)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.stopSpinning()
                    self.delegate?.didNotFindWeather()
                }
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionID = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            let description = decodedData.weather[0].description
            let feelsLikeTemp = decodedData.main.feels_like
            let tempMin = decodedData.main.temp_min
            let tempMax = decodedData.main.temp_max
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let wind = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            let cloud = decodedData.clouds.all
            let pressure = decodedData.main.pressure
            let timeZone = decodedData.timezone
            let weather = WeatherModel(conditionID: conditionID, city: city, temp: temp, description: description, feelsLikeTemp: feelsLikeTemp, tempMin: tempMin, tempMax: tempMax, sunrise: sunrise, sunset: sunset, wind: wind, humidity: humidity, cloud: cloud, pressure: pressure, timeZone: timeZone)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}

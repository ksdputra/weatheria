//
//  WeatherManager.swift
//  Weatheria
//
//  Created by Kharisma Putra on 08/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentWeatherManagerDelegate {
    func didUpdateWeather(weather: CurrentWeatherModel)
    func didNotFindWeather()
    func startSpinning()
    func stopSpinning()
}

struct CurrentWeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=e72ca729af228beabd5d20e3b7749713&units=metric"
    var delegate: CurrentWeatherManagerDelegate?
    
    mutating func fetchWeather(of cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(url)&q=\(city)"
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
            self.delegate?.startSpinning()
            task.resume()
        } else {
            self.delegate?.didNotFindWeather()
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
    
    func parseJSON(weatherData: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: weatherData)
            let conditionID = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            let icon = decodedData.weather[0].icon
            let description = decodedData.weather[0].description
            let feelsLikeTemp = decodedData.main.feels_like
            let tempMin = decodedData.main.temp_min
            let tempMax = decodedData.main.temp_max
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let wind = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            let clouds = decodedData.clouds.all
            let pressure = decodedData.main.pressure
            let timezone = decodedData.timezone
            let weather = CurrentWeatherModel(conditionID: conditionID, city: city, temp: temp, icon: icon, description: description, feelsLikeTemp: feelsLikeTemp, tempMin: tempMin, tempMax: tempMax, sunrise: sunrise, sunset: sunset, wind: wind, humidity: humidity, clouds: clouds, pressure: pressure, timezone: timezone)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}

//
//  ViewController.swift
//  Weatheria
//
//  Created by Kharisma Putra on 06/06/20.
//  Copyright © 2020 Kharisma Putra. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var areaSearchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        areaSearchBar.delegate = self
        activityIndicatorView.isHidden = true
        currentLocationButton.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        areaSearchBar.endEditing(true)
        
        if areaSearchBar.text == "" {
            let nilAlert = UIAlertController(title: "Search Field Cannot Be Empty", message: "Please Fill Any City To Continue", preferredStyle: .alert)
            nilAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(nilAlert, animated: true, completion: nil)
        } else if let cityName = areaSearchBar.text {
            weatherManager.fetchWeather(of: cityName)
        }
        
        areaSearchBar.text = ""
        currentLocationButton.isHidden = false
    }
}

// MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        cityLabel.text = weather.city
        tempLabel.text = String(weather.temp)
        weatherImageView.image = UIImage(systemName: weather.conditionName)
        descriptionLabel.text = weather.description
        feelsLikeTempLabel.text = "Feels like \(String(weather.feelsLikeTemp))°"
        minTempLabel.text = "\(String(weather.tempMin))°"
        maxTempLabel.text = "\(String(weather.tempMax))°"
//        sunriseLabel.text =
//        sunsetLabel.text =
        windSpeedLabel.text = "\(String(weather.wind)) m/s"
        humidityLabel.text = "\(String(weather.humidity))%"
        cloudsLabel.text = "\(String(weather.cloud))%"
        pressureLabel.text = "\(String(weather.pressure)) hPa"
        backgroundView.backgroundColor = weather.conditionColor
    }
    
    func didNotFindWeather() {
        let errorAlert = UIAlertController(title: "Error", message: "Area can't be found.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func startSpinning() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopSpinning() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            currentLocationButton.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

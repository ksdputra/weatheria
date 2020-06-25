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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
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
    @IBOutlet weak var currentView: UIView!
    
    @IBOutlet weak var hourlyView: UIView!
    @IBOutlet weak var hourlyLabel: UILabel!
    
    
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var temp1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var temp2Label: UILabel!
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var temp3Label: UILabel!
    @IBOutlet weak var date4Label: UILabel!
    @IBOutlet weak var temp4Label: UILabel!
    @IBOutlet weak var date5Label: UILabel!
    @IBOutlet weak var temp5Label: UILabel!
    @IBOutlet weak var date6Label: UILabel!
    @IBOutlet weak var temp6Label: UILabel!
    @IBOutlet weak var date7Label: UILabel!
    @IBOutlet weak var temp7Label: UILabel!
    @IBOutlet weak var date8Label: UILabel!
    @IBOutlet weak var temp8Label: UILabel!
    
    
    
    var weatherManager = WeatherManager()
    var forecastManager = ForecastManager()
    let locationManager = CLLocationManager()
    var timer = Timer()
    var timeZone: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        forecastManager.delegate = self
        areaSearchBar.delegate = self
        activityIndicatorView.isHidden = true
        currentLocationButton.isHidden = true
        currentView.isHidden = false
        hourlyView.isHidden = true
        dailyView.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Function

extension ViewController {
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentView.isHidden = false
            hourlyView.isHidden = true
            dailyView.isHidden = true
        case 1:
//            segmentedControl.selectedSegmentIndex = 0
//            failedAlert()
            currentView.isHidden = true
            hourlyView.isHidden = false
            dailyView.isHidden = true
        case 2:
//            segmentedControl.selectedSegmentIndex = 0
//            failedAlert()
            currentView.isHidden = true
            hourlyView.isHidden = true
            dailyView.isHidden = false
        default:
            break
        }
    }
    
    func failedAlert() {
        let alertController = UIAlertController(title: "Feature in Progress", message: "Will be updated ASAP", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alertController, animated: true, completion: nil)
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
            let alertController = UIAlertController(title: "Search Field Cannot Be Empty", message: "Please Fill Any City To Continue", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
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
        timeZone = Double(weather.timeZone)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        tempLabel.text = weather.getTemp()
        setImage(from: weather.getImageUrl())
        descriptionLabel.text = weather.description
        feelsLikeTempLabel.text = weather.getFeelsLikeTemp()
        minTempLabel.text = weather.getMinTemp()
        maxTempLabel.text = weather.getMaxTemp()
        sunriseLabel.text = weather.getSunrise()
        sunsetLabel.text = weather.getSunset()
        windSpeedLabel.text = weather.getWindSpeed()
        humidityLabel.text = weather.getHumidity()
        cloudsLabel.text = weather.getClouds()
        pressureLabel.text = weather.getPressure()
        backgroundView.backgroundColor = weather.conditionColor
        
        hourlyLabel.text = "HOURLY!!"
        
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
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.weatherImageView.image = image
            }
        }
    }
    
    @objc func tick() {
        let format = DateFormatter()
        format.dateFormat = "EEEE, d MMM y HH:mm:ss"
        format.timeZone = TimeZone(identifier: "UTC")
        dateTimeLabel.text = format.string(from: Date() + timeZone!)
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
            forecastManager.fetchWeather(latitude: lat, longitude: lon)
            currentLocationButton.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: ForecastManagerDelegate {
    func didUpdateForecast(forecast: OneCallModel) {
        let dates = forecast.getDate()
        date1Label.text = dates[0]
        date2Label.text = dates[1]
        date3Label.text = dates[2]
        date4Label.text = dates[3]
        date5Label.text = dates[4]
        date6Label.text = dates[5]
        date7Label.text = dates[6]
        date8Label.text = dates[7]
        
        let temps = forecast.getTemps()
        temp1Label.text = temps[0]
        temp2Label.text = temps[1]
        temp3Label.text = temps[2]
        temp4Label.text = temps[3]
        temp5Label.text = temps[4]
        temp6Label.text = temps[5]
        temp7Label.text = temps[6]
        temp8Label.text = temps[7]
    }
    
    
}

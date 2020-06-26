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
    
    @IBOutlet weak var hourlyTableView: UITableView!
    @IBOutlet weak var dailyTableView: UITableView!
    var dailyForecast: [DailyForecastModel] = []
    var currentWeatherManager = CurrentWeatherManager()
    var dailyForecastManager = DailyForecastManager()
    let locationManager = CLLocationManager()
    var timer = Timer()
    var timeZone: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        dailyTableView.dataSource = self
        dailyTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        dailyTableView.rowHeight = 68.5
        
        currentWeatherManager.delegate = self
        dailyForecastManager.delegate = self
        areaSearchBar.delegate = self
        activityIndicatorView.isHidden = true
        currentLocationButton.isHidden = true
        currentView.isHidden = false
        hourlyTableView.isHidden = true
        dailyTableView.isHidden = true
        
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
            hourlyTableView.isHidden = true
            dailyTableView.isHidden = true
        case 1:
            currentView.isHidden = true
            hourlyTableView.isHidden = false
            dailyTableView.isHidden = true
        case 2:
            currentView.isHidden = true
            hourlyTableView.isHidden = true
            dailyTableView.isHidden = false
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
            // For current weather
            currentWeatherManager.fetchWeather(of: cityName)
            
            // For forecast weather
            CLGeocoder().geocodeAddressString(cityName) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                self.dailyForecastManager.fetchWeather(latitude: lat!, longitude: lon!)
            }
        }
        
        areaSearchBar.text = ""
        currentLocationButton.isHidden = false
    }
}

// MARK: - CurrentWeatherManagerDelegate

extension ViewController: CurrentWeatherManagerDelegate {
    
    func didUpdateWeather(weather: CurrentWeatherModel) {
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
            currentWeatherManager.fetchWeather(latitude: lat, longitude: lon)
            dailyForecastManager.fetchWeather(latitude: lat, longitude: lon)
            currentLocationButton.isHidden = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - DailyForecastManagerDelegate

extension ViewController: DailyForecastManagerDelegate {
    
    func didUpdateForecast(forecasts: [DailyForecastModel]) {
        dailyForecast = []
        dailyForecast.append(contentsOf: forecasts)
        self.dailyTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! DailyTableViewCell
        cell.dateLabel.text = dailyForecast[indexPath.row].getDate()
        cell.tempLabel.text = dailyForecast[indexPath.row].getTemp()
        cell.descriptionLabel.text = dailyForecast[indexPath.row].description
        return cell
    }
}

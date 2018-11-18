//
//  DetailViewController.swift
//  PrognozaPogodyExtUI
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if detailItem != nil {
            currentlyDisplayedWeatherInd = 0
            if (!detailItem!.weathers.isEmpty) {
                updateView(dayWeather: detailItem?.weathers[0] ?? DayWeatherInLocation())
            } else {
                print("WARNING" + detailItem!.location + "Has No Weather data")
            
            }
            
        }
    }

    var detailItem: WeathersInLocation? {
        didSet {
            // Update the view.
            configureView()
        }
    }


    @IBOutlet weak var weatherStateImage: UIImageView!
    
    @IBOutlet weak var dateOfActiveWeather: UILabel!
    @IBOutlet weak var infoContainer: UILabel!
    @IBOutlet weak var weatherState: UILabel!
    
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDir: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        print("NEXT button pressed")
        if (currentlyDisplayedWeatherInd < (detailItem?.weathers.count ?? 0) - 1) {
            currentlyDisplayedWeatherInd = currentlyDisplayedWeatherInd + 1
            updateView(dayWeather: detailItem?.weathers[currentlyDisplayedWeatherInd] ?? DayWeatherInLocation())
        }
        buttonsAvailability()
    }
    
    @IBAction func prevButtonAction(_ sender: UIButton) {
        print("         PREV button pressed")
        if (currentlyDisplayedWeatherInd > 0) {
            currentlyDisplayedWeatherInd = currentlyDisplayedWeatherInd - 1
            updateView(dayWeather: detailItem?.weathers[currentlyDisplayedWeatherInd] ?? DayWeatherInLocation())
        }
        buttonsAvailability()
    }
    
    func buttonsAvailability() {
        let weatherCount = detailItem?.weathers.count ?? 0
        prevButton.isEnabled=true
        nextButton.isEnabled=true
        if (currentlyDisplayedWeatherInd == 0) {
            prevButton.isEnabled = false
        }
        if (currentlyDisplayedWeatherInd == weatherCount - 1) {
            nextButton.isEnabled = false
        }
    }

    var currentlyDisplayedWeatherInd = 0
    
    
    func updateView(dayWeather: DayWeatherInLocation) {
        DispatchQueue.main.async {
            self.header.title = self.detailItem?.location
            self.weatherStateImage.image =  WeatherDAO.downloadedImages[dayWeather.weather_state_abbr]
            self.weatherState.text = dayWeather.weather_state_name
            self.dateOfActiveWeather.text = dayWeather.applicable_date
            self.minTemp.text = String(format:"%.1f°C", dayWeather.min_temp.floatValue)
            self.maxTemp.text = String(format:"%.1f°C", dayWeather.max_temp.floatValue)
            self.windSpeed.text = String(format:"%.2f km/h", dayWeather.wind_speed.floatValue)
            self.windDir.text = String(format:"%d", dayWeather.wind_direction.floatValue)
            self.pressure.text = String(format:"%d hPa", dayWeather.air_pressure.floatValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepVisually()
    }
    
    func prepVisually() {
        dateOfActiveWeather.textAlignment = NSTextAlignment.center
        minTempLabel.textAlignment = NSTextAlignment.right
        maxTempLabel.textAlignment = NSTextAlignment.right
        windSpeedLabel.textAlignment = NSTextAlignment.right
        windDirLabel.textAlignment = NSTextAlignment.right
        pressureLabel.textAlignment = NSTextAlignment.right
        prevButton.isEnabled = false
    }
}


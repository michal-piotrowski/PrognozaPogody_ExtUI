//
//  DetailViewController.swift
//  PrognozaPogodyExtUI
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.location
            }
        }
    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        configureView()
//    }

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
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        print("NEXT button pressed")
        if (currentlyDisplayedWeatherNo < weathers.count - 1) {
            currentlyDisplayedWeatherNo = currentlyDisplayedWeatherNo + 1
            updateView(dayWeather: weathers[currentlyDisplayedWeatherNo])
        }
    }
    
    @IBAction func prevButtonAction(_ sender: UIButton) {
        print("         PREV button pressed")
        if (currentlyDisplayedWeatherNo > 0) {
            currentlyDisplayedWeatherNo = currentlyDisplayedWeatherNo - 1
            updateView(dayWeather: weathers[currentlyDisplayedWeatherNo])
        }
    }
    
    
    
    let WOEID_WARSAW: String = "523920"
    var imageCache: [String: UIImage] = [:]
    var weathers: [DayWeatherInLocation]! = []
    var currentlyDisplayedWeatherNo = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepVisually()
        getWeatherInformationForWOEID(woeid: WOEID_WARSAW)
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
    
    func getWeatherInformationForWOEID(woeid: String) {
        let url: URL = URL(string: "https://www.metaweather.com/api/location/\(woeid)/")!
        let session = URLSession.shared
        var json: [String: Any] = [:]
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    self.weathers = self.getWeatherForNDays(json: json)
                    self.setInitialView()
                }
                catch
                {
                    return
                }
            }
        })
        task.resume()
    }
    /**
     "id": 6722833333878784,
     "weather_state_name": "Light Cloud",
     "weather_state_abbr": "lc",
     "wind_direction_compass": "SE",
     "created": "2018-10-16T16:02:12.247823Z",
     "applicable_date": "2018-10-16",
     "min_temp": 6.1933333333333325,
     "max_temp": 19.176666666666666,
     "the_temp": 18.630000000000003,
     "wind_speed": 2.9387014361064714,
     "wind_direction": 140.3131693036207,
     "air_pressure": 1022.5450000000001,
     "humidity": 61,
     "visibility": 10.001901395848247,
     "predictability": 70
     */
    func getWeatherForNDays (json: [String: Any]?) -> [DayWeatherInLocation] {
        var weathers: [DayWeatherInLocation] = [DayWeatherInLocation]()
        for i in 0...(json!["consolidated_weather"] as! [[String: Any]]).count - 1 {
            let singleWeatherDict = (json!["consolidated_weather"]as! [[String: Any]])[i]
            let dayWeather = DayWeatherInLocation()
            dayWeather.min_temp = (singleWeatherDict["min_temp"] as! NSNumber)
            dayWeather.max_temp = (singleWeatherDict["max_temp"] as! NSNumber)
            dayWeather.weather_state_name = (singleWeatherDict["weather_state_name"] as! String)
            dayWeather.weather_state_abbr = (singleWeatherDict["weather_state_abbr"] as! String)
            dayWeather.wind_speed = (singleWeatherDict["wind_speed"] as! NSNumber)
            dayWeather.wind_direction = (singleWeatherDict["wind_direction"] as! NSNumber)
            dayWeather.air_pressure = (singleWeatherDict["air_pressure"] as! NSNumber)
            dayWeather.applicable_date = (singleWeatherDict["applicable_date"] as! String)
            getImage(typeAbbr: dayWeather.weather_state_abbr!)
            weathers.append(dayWeather)
        }
        return weathers;
    }
    
    func setInitialView() {
        currentlyDisplayedWeatherNo = 0
        updateView(dayWeather: self.weathers[0])
    }
    
    func updateView(dayWeather: DayWeatherInLocation) {
        DispatchQueue.main.async {
            self.weatherStateImage.image = self.imageCache[dayWeather.weather_state_abbr]
            self.weatherState.text = dayWeather.weather_state_name
            self.dateOfActiveWeather.text = dayWeather.applicable_date
            self.minTemp.text = String(format:"%.1f°C", dayWeather.min_temp.floatValue)
            self.maxTemp.text = String(format:"%.1f°C", dayWeather.max_temp.floatValue)
            self.windSpeed.text = String(format:"%.2f km/h", dayWeather.wind_speed.floatValue)
            self.windDir.text = String(format:"%d", dayWeather.wind_direction.floatValue)
            self.pressure.text = String(format:"%d hPa", dayWeather.air_pressure.floatValue)
        }
    }
    
    func getImage(typeAbbr:String) {
        let url: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/\(typeAbbr).png")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                print("image data isn't nil")
                if (self.imageCache[typeAbbr] == nil){
                    let img = UIImage(data: data!)
                    self.imageCache[typeAbbr] = img
                }
            }
        })
        task.resume()
    }
}


//
//  WeatherDAO.swift
//  PrognozaPogodyExtUI
//
//  Created by Student on 30/10/2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//
import UIKit
import Foundation

class WeatherDAO {
//
//    static var imageCache: [String: UIImage] = [:]
//
    static var img: UIImage!
    static func getWeatherInformationForWOEID(woeid: String, locationName: String) -> WeathersInLocation {
        let locationWeathers: WeathersInLocation = WeathersInLocation()
        locationWeathers.location = locationName
        let url: URL = URL(string: "https://www.metaweather.com/api/location/\(woeid)/")!
        let session = URLSession.shared
        var json: [String: Any] = [:]
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    locationWeathers.weathers = self.getWeatherForNDays(json: json)
                    //                    self.setInitialView()
                }
                catch
                {
                    return
                }
            }
        })
        task.resume()
        return locationWeathers
    }
    
    static func getWeatherForNDays (json: [String: Any]?) -> [DayWeatherInLocation] {
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
            dayWeather.weather_state_image = WeatherDAO.getImage(typeAbbr: dayWeather.weather_state_abbr!)
            weathers.append(dayWeather)
        }
        return weathers;
    }
    /**
     TODO: REFACTOR self.imageCache[typeAbbr] == nil
     TO BE CHECKED BEFORE CREATING URL, SESSION, TASK
     */
    static func getImage(typeAbbr:String) -> UIImage {
        let url: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/\(typeAbbr).png")!
        let session = URLSession.shared
        self.img = nil
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                print("image data isn't nil")
                self.img = UIImage(data: data!)!
            }
        })
        task.resume()
        return self.img
    }
}

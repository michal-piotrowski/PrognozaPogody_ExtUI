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
    static var downloadedImages: [String: UIImage] = [:]

    
    static func getWeatherInformationForWOEID(woeid: String, locationName: String) -> WeathersInLocation {
        let locationWeathers: WeathersInLocation = WeathersInLocation()
        locationWeathers.location = locationName
        locationWeathers.woeid = woeid
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
    
    static func fillTableViewCellWithWeather(woeid: String, locationName: String, weatherCell: WeatherTableCell) -> WeathersInLocation {
        let locationWeathers: WeathersInLocation = WeathersInLocation()
        locationWeathers.location = locationName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: Date())
        let url: URL = URL(string: "https://www.metaweather.com/api/location/\(woeid)/\(dateStr)")!
        let session = URLSession.shared
        var json: [String: Any] = [:]
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
//                    locationWeathers.weathers = self.getWeatherForNDays(json: json)
                    //                    self.setInitialView()
                    let singleWeatherDict = ( json["consolidated_weather"]as! [[String: Any]])[0]
                    DispatchQueue.main.async {
                        weatherCell.cityName.text = locationName
                        weatherCell.temperature.text = String(format:"%.1f", singleWeatherDict["the_temp"] as! NSNumber) 
                    }
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
            WeatherDAO.downloadImage(typeAbbr: dayWeather.weather_state_abbr!)
            weathers.append(dayWeather)
        }
        return weathers;
    }
    /**
     TODO: REFACTOR self.imageCache[typeAbbr] == nil
     TO BE CHECKED BEFORE CREATING URL, SESSION, TASK
     */
    static func downloadImage(typeAbbr:String) {
        if (downloadedImages.keys.contains(typeAbbr)) {
            return
        }
        let url: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/\(typeAbbr).png")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if (error != nil) {
                print(error!)
                return
            }
            if data != nil {
                self.downloadedImages[typeAbbr] = UIImage(data: data!)
            }
        })
        task.resume()
    }
}

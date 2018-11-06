//
//  DayWeather.swift
//  PrognozaPogody
//
//  Created by Student on 16/10/2018.
//  Copyright © 2018 IHaveAMacNow. All rights reserved.
//

import Foundation
import UIKit

class DayWeatherInLocation {
    var location: String!
    var min_temp: NSNumber!
    var max_temp: NSNumber!
    var weather_state_name: String!
    var weather_state_abbr: String!
    var wind_speed: NSNumber!
    var wind_direction: NSNumber!
    var air_pressure: NSNumber!
    var applicable_date: String!
    var weather_state_image: UIImage!
}

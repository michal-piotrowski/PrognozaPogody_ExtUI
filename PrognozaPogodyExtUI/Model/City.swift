//
//  City.swift
//  PrognozaPogodyExtUI
//
//  Created by IHaveAMacNow on 12/11/2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import Foundation

class City {
    var cityName: String
    var woeid: String
    
    init(cityName: String, woeid: String) {
        self.cityName = cityName
        self.woeid = woeid
    }
}

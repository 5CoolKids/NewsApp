//
//  WeatherModel.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/12/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let temperture: Double
    let weatherCondition: String
    
    var tempertureString: String {
        return String(format:"%.0f", temperture) + "°C"
    }
    
    var weatherName: String {
        switch conditionId {
        case 200...232:
            return "thunder_weather"
        case 500...531:
            return "rainy_weather"
        case 600...622:
            return "snowy_weather"
        case 800:
            return "clear_weather"
        case 801...804:
            return "cloudy_weather"
        default:
            return "sunny_weather"
        }
    }
}

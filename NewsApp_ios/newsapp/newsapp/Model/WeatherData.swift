//
//  WeatherData.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/12/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import Foundation
import UIKit

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let main: String
    let id: Int
}

class WeatherInfo {
    var image: UIImage
    var city: String
    var state: String
    var temp: String
    var condition: String
    
    init(image: UIImage, temp: String, condition: String, city: String, state: String) {
        self.image = image
        self.temp = temp
        self.condition = condition
        self.city = city
        self.state = state
    }
    
    func setCity(city: String) {
        self.city = city
    }
    
    func setState(state: String) {
        self.state = state
    }
    
    func setOther(image: UIImage, temp: String, condition: String) {
        self.image = image
        self.temp = temp
        self.condition = condition
    }
}

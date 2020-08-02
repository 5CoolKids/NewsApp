//
//  WeatherCell.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/13/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var cLabel: UILabel!
    
    @IBOutlet weak var wLabel: UILabel!
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    
    func setWeather(weatherInfo: WeatherInfo) {
        backgroundImgView.image = weatherInfo.image
        tLabel.text = weatherInfo.temp
        cLabel.text = weatherInfo.city
        wLabel.text = weatherInfo.condition
        sLabel.text = weatherInfo.state
    }
    
}

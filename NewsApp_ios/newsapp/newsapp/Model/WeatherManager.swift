//
//  WeatherManager.swift
//  newsapp
//
//  Created by Yueyang Cheng on 4/12/20.
//  Copyright © 2020 Yueyang Cheng. All rights reserved.
//

import Foundation
import Alamofire

let weatherApiKey = "0f5760d8020ca94971e6f13817590953"

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(weatherApiKey)"

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let cityStr:String = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(cityStr)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseJSON { response in
                if let safeData = response.data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let condition = decodedData.weather[0].main
            
            let weather = WeatherModel(conditionId: id, temperture: temp, weatherCondition: condition)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}


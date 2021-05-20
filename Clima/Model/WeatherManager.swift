//
//  WeatherManager.swift
//  Clima
//
//  Created by Mickale Saturre on 3/19/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2de631c3b2a9b35916afc6f97eb80555&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let url = "\(weatherURL)&q=\(cityName)"
        
        performRequest(url)
    }
    
    func fetchWeather(_ latitude: Double, _ longtitude: Double) {
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        
        performRequest(url)
    }
    
    func performRequest(_ url: String) {
        if let performURL = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: performURL) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    
                    return
                }
                
                if let safeData = data {
                    if let weather = objectParser(safeData) {
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func objectParser(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()

        do {
            let object = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = object.main.temp
            let name = object.name
            let weather = WeatherModel(conditionId: object.weather[0].id, cityName: name, temperature:  temp)

            return weather
        } catch {
            delegate?.didFailWithError(error)
            
            return nil
        }
    }
}

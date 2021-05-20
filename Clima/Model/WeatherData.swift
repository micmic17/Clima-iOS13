//
//  WeatherData.swift
//  Clima
//
//  Created by Mickale Saturre on 3/19/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Codable {
    let main: String
    let description: String
    let id: Int
}

struct Main: Codable {
    let temp: Double
}

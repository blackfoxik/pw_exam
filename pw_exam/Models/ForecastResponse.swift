//
//  ForecastResponse.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

// MARK: - Корневой объект Forecast
struct ForecastResponse: Codable, Hashable {
    let location: WeatherLocation
    let current: CurrentWeatherModel
    let forecast: Forecast
}

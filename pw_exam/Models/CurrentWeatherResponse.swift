//
//  CurrentWeatherResponse.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

// MARK: - Корневой объект ответа
struct CurrentWeatherResponse: Codable, Hashable {
    let location: WeatherLocation
    let current: CurrentWeatherModel
}









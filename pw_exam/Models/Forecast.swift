//
//  Forecast.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

// MARK: - Прогноз
struct Forecast: Codable, Hashable {
    let forecastday: [ForecastDay]
}

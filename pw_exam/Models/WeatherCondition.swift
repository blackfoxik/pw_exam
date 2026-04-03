//
//  WeatherCondition.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

// MARK: - Состояние погоды
struct WeatherCondition: Codable, Hashable {
    let text: String
    let icon: String
    let code: Int
}

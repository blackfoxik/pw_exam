//
//  WeatherLocation.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

// MARK: - Локация
struct WeatherLocation: Codable, Hashable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

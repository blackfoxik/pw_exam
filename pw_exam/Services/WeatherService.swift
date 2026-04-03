//
//  WeatherService.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrenWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse
    func fetchWeatherForecast(lat: Double, lon: Double, days: Int) async throws -> ForecastResponse
}

final class WeatherService: WeatherServiceProtocol {
    
    private let api: APIClientProtocol
    
    init(api: APIClientProtocol = APIClient()) {
        self.api = api
    }
    
    func fetchCurrenWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
        let endpoint = WeatherEndpoint(lat: lat, lon: lon, endpoint: .current)
        let response: CurrentWeatherResponse = try await api.request(endpoint)
        
        return response
    }
    
    func fetchWeatherForecast(lat: Double, lon: Double, days: Int) async throws -> ForecastResponse {
        let endpoint = WeatherEndpoint(lat: lat, lon: lon, endpoint: .forecast, days: days)
        let response: ForecastResponse = try await api.request(endpoint)
        
        return response
    }
}

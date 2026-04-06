//
//  WeatherViewModel.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Combine
import Foundation

enum WeatherViewState {    
    case loading
    case loaded((CurrentWeatherResponse, ForecastResponse))
    case error(String)
}

final class WeatherViewModel {
    @Published private(set) var state: WeatherViewState = .loading
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    @MainActor
    func loadWeatherForecast(lat: Double, lon: Double, days: Int) async {
        state = .loading
        do {
            async let current = self.service.fetchCurrenWeather(lat: lat, lon: lon)
            async let forecast = self.service.fetchWeatherForecast(lat: lat, lon: lon, days: days)
            let response = try await (current, forecast)
            state = .loaded((response.0, response.1))
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadWeatherForDefaultLocation() async {
        //moscow location
        let lat: Double = 55.75344348971641
        let lon: Double = 37.607554664773865
        await loadWeatherForecast(lat: lat, lon: lon, days: 3)
    }
}

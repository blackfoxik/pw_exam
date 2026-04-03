//
//  Endpoint.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    
    var baseURL: String {
        "https://api.weatherapi.com/v1/"
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        return components?.url
    }
}

struct WeatherEndpoint: Endpoint {
    enum Endpoint: String {
        case current = "current.json"
        case forecast = "forecast.json"
    }
 
    var lat: Double
    var lon: Double
    
    var endpoint: Endpoint = .current
    var days: Int? = nil
    
    private var apiKey = "63e570ec2a414e74b9684845260204"
    
    var path: String {
        endpoint.rawValue
    }
    
    var method: String {
        "GET"
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItems =
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(lat),\(lon)")
        ]
        
        if let days = days, case .forecast = endpoint {
            queryItems.append(URLQueryItem(name: "days", value: "\(days)"))
        }
        
        return queryItems
    }
    
    init (lat: Double, lon: Double, endpoint: Endpoint, days: Int? = nil) {
        self.lat = lat
        self.lon = lon
        self.endpoint = endpoint
        self.days = days
    }
}

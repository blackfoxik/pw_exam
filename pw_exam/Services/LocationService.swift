//
//  LocationService.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Combine
import CoreLocation

enum LocationServiceError: Error {
    case unauthorized
}

class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var locationPublisher = PassthroughSubject<CLLocation, Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationPublisher.send(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorPublisher.send(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            errorPublisher.send(LocationServiceError.unauthorized)
        }
    }
}

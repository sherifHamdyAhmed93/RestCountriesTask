//
//  LocationManager.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import Foundation
import CoreLocation
import Combine

class LocationManager:NSObject{
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private let country = PassthroughSubject<String, Never>()
    var countryPublisher: AnyPublisher<String, Never> {
        country.eraseToAnyPublisher()
    }

    override init(){
        super.init()
        manager.delegate = self
    }
    
    func requestAccessToLocation(){
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    private func sendDefaultCountry(){
        country.send("EG")
    }
    
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            sendDefaultCountry()
            return
        }

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let countryCode = placemarks?.first?.isoCountryCode {
                self?.country.send(countryCode)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        sendDefaultCountry()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            sendDefaultCountry()
        }
    }
}


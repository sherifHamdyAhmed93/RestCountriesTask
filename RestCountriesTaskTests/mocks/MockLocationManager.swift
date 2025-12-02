//
//  MockLocationManager.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import Foundation
import Combine

final class MockLocationManager {

    private let countrySubject = PassthroughSubject<String, Never>()
    var countryPublisher: AnyPublisher<String, Never> {
        countrySubject.eraseToAnyPublisher()
    }
    
    func sendCountry(_ code: String) {
        countrySubject.send(code)
    }
    
    func sendDefaultCountry() {
        countrySubject.send("EG")
    }
    
    func sendDenied() {
        countrySubject.send("EG")
    }
    
    func requestAccessToLocation() {}
}

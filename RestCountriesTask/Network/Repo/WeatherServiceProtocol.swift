//
//  WeatherServiceProtocol.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import Foundation
import Combine

protocol CountryServiceProtocol{
    func getAllCountries()->AnyPublisher<[CountryResponse],Error>
}

final class CountryService : CountryServiceProtocol{
    
    let networkService:NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getAllCountries()->AnyPublisher<[CountryResponse],Error>{
        let route = CountryRoute.allCountries
        return networkService.request(route, type: [CountryResponse].self)
    }
    
}

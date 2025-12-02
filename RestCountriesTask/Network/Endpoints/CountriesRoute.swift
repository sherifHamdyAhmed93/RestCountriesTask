//
//  WeatherRoute.swift
//  WeatherAppTask
//
//  Created by Sherif Hamdy on 25/10/2025.
//

import Foundation

enum CountryRoute : RouteProtocol{
    case allCountries
    
    var path: String{
        switch self {
        case .allCountries:
            return "/all?fields=name,capital,currencies,flags,alpha2Code"
        }
    }
    
}

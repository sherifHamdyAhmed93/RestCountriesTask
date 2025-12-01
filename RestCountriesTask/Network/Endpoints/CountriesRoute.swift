//
//  WeatherRoute.swift
//  WeatherAppTask
//
//  Created by Sherif Hamdy on 25/10/2025.
//

import Foundation

enum CountryRoute : RouteProtocol{
    case city(cityName:String)
    
    var path: String{
        switch self {
        case .city(let cityName):
            return "/name/\(cityName)"
        }
    }
    
}

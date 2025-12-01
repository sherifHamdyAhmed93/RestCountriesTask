//
//  EndpointProtocol.swift
//  WeatherAppTask
//
//  Created by Sherif Hamdy on 25/10/2025.
//


import Foundation

protocol RouteProtocol {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
}

extension RouteProtocol {
    var baseURL: String {
        NetworkConstants.baseURL
    }
        
    var url: URL? {
        return URL(string: baseURL + path)
    }
}

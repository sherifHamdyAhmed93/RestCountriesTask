//
//  CountryResponse.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import Foundation

struct CountryResponse: Decodable {
    let common:String
    let cca2: String
    let capital: [String]?
    let currencies: [String: CurrencyResponse]?
    let flags: FlagResponse?
}

struct CurrencyResponse: Decodable {
    let name: String
    let symbol: String?
}

struct FlagResponse: Decodable {
    let png: String?
}

//
//  CountryResponse.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import Foundation

struct CountryResponse: Decodable {
    let name:String
    let capital: String?
    let currencies: [CurrencyResponse]?
    let flags: FlagResponse?
    let alpha2Code:String
}
struct CurrencyResponse: Decodable {
    let code:String
    let name: String
    let symbol: String?
}

struct FlagResponse: Decodable {
    let png: String?
}

//
//  CountryUIModel.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import Foundation
import SwiftData

@Model
class CountryUIModel : Identifiable , Hashable {
    //var id: String
    var capital: String
    var countryName: String
    var currencyName: String
    var currencySymbol: String
    var flagURL: URL?
    var countryCode:String = ""
    
    init(capital: String, countryName: String, currencyName: String, currencySymbol: String, flagURL: URL? = nil,countryCode:String) {
        self.capital = capital
        self.countryName = countryName
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.flagURL = flagURL
        self.countryCode = countryCode
    }
    
    
    init(from response: CountryResponse) {
        //self.id = response.name
        self.capital = response.capital ?? ""
        self.countryName = response.name
        let currency = response.currencies?.first
        self.currencyName = currency?.name ?? ""
        self.currencySymbol = currency?.symbol ?? ""
        self.countryCode = response.alpha2Code
        if let png = response.flags?.png, !png.isEmpty {
            self.flagURL = URL(string: png)
        }else{
            flagURL = nil
        }
    }
}

extension CountryUIModel : Equatable{
    static func == (lhs: CountryUIModel, rhs: CountryUIModel) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
}



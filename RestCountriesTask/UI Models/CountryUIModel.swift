//
//  CountryUIModel.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import Foundation
struct CountryUIModel : Identifiable {
    let id: String
    let capital: String
    let currencyName: String
    let currencySymbol: String
    let flagURL: URL?
}

extension CountryUIModel {
    init(from response: CountryResponse) {
        self.id = response.cca2
        self.capital = response.capital?.first ?? ""
        
        let currency = response.currencies?.values.first
        self.currencyName = currency?.name ?? ""
        self.currencySymbol = currency?.symbol ?? ""
        
        if let png = response.flags?.png, !png.isEmpty {
            self.flagURL = URL(string: png)
        }else{
            flagURL = nil
        }
    }
}

//
//  CountryRowView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct CountryRowView: View {
    let country:CountryUIModel
    var body: some View {
        HStack(spacing: 16.0) {
            CircularAsyncImage(url: country.flagURL, size: 40)
            CountryInfoView(capital: country.capital, currencyName: country.currencyName)
        }
    }
}

#Preview {
    let country = CountryUIModel(
        id: "QA",
        capital: "Doha",
        countryName: "Qatar",
        currencyName: "Qatari Riyal",
        currencySymbol: "QAR",
        flagURL: URL(string: "https://flagcdn.com/w320/qa.png")
    )
    CountryRowView(country: country)
}

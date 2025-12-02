//
//  DetailsView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    let country:CountryUIModel
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            CircularAsyncImage(url: country.flagURL, size: UIScreen.main.bounds.width / 2)
            
            CountryInfoView(
                capital: country.capital,
                currencyName: country.currencyName
                ,capitalFont: .system(size: 30, weight: .bold, design: .rounded),
                currencyFont: .system(size: 20, weight: .medium, design: .rounded),
                alignment: .center)
            
        }
        
        .navigationTitle(country.countryName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25, weight: .bold))
                            .tint(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    let country = CountryUIModel(
//        id: "QA",
        capital: "Doha", countryName: "Qatar",
        currencyName: "Qatari Riyal",
        currencySymbol: "QAR",
        flagURL: URL(string: "https://flagcdn.com/w320/qa.png")
    )
    NavigationStack {
        DetailsView(country: country)
    }
}

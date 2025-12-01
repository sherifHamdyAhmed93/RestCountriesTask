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
            if let flagURL = country.flagURL{
                AsyncImage(url: flagURL) { image in
                    image
                    .resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.width/2)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 5)
            }
            
            
            VStack(alignment: .center, spacing: 5.0){
                Text(country.capital)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(country.currencyName)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    let country = CountryUIModel(
        id: "QA",
        capital: "Doha",
        currencyName: "Qatari Riyal",
        currencySymbol: "QAR",
        flagURL: URL(string: "https://flagcdn.com/w320/qa.png")
    )
    DetailsView(country: country)
}

//
//  ContentView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State var mockedCountries: [CountryUIModel] = [
        CountryUIModel(
            id: "QA",
            capital: "Doha",
            currencyName: "Qatari Riyal",
            currencySymbol: "QAR",
            flagURL: URL(string: "https://flagcdn.com/w320/qa.png")
        ),
        CountryUIModel(
            id: "SA",
            capital: "Riyadh",
            currencyName: "Saudi Riyal",
            currencySymbol: "SAR",
            flagURL: URL(string: "https://flagcdn.com/w320/sa.png")
        ),
        CountryUIModel(
            id: "EG",
            capital: "Cairo",
            currencyName: "Egyptian Pound",
            currencySymbol: "EGP",
            flagURL: URL(string: "https://flagcdn.com/w320/eg.png")
        ),
        CountryUIModel(
            id: "AE",
            capital: "Abu Dhabi",
            currencyName: "UAE Dirham",
            currencySymbol: "AED",
            flagURL: URL(string: "https://flagcdn.com/w320/ae.png")
        ),
        CountryUIModel(
            id: "KW",
            capital: "Kuwait City",
            currencyName: "Kuwaiti Dinar",
            currencySymbol: "KWD",
            flagURL: URL(string: "https://flagcdn.com/w320/kw.png")
        )
    ]
    var body: some View {
        List {
            ForEach(mockedCountries) { country in
                CountryRowView(country: country)
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(_ indexSet:IndexSet){
        self.mockedCountries.remove(atOffsets: indexSet)
    }
}

#Preview {
    ContentView()
}

struct CountryRowView: View {
    let country:CountryUIModel
    var body: some View {
        HStack(spacing: 16.0) {
            if let flagURL = country.flagURL{
                AsyncImage(url: flagURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 40, height: 40)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 5)
            }
            VStack(alignment: .leading, spacing: 5.0){
                Text(country.capital)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(country.currencyName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

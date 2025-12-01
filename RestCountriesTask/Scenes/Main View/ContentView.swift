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


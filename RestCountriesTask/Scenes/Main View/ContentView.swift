//
//  ContentView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCountry: CountryUIModel?
    
    @State var mockedCountries: [CountryUIModel] = [
        CountryUIModel(
            id: "QA",
            capital: "Doha",countryName: "Qatar",
            currencyName: "Qatari Riyal",
            currencySymbol: "QAR",
            flagURL: URL(string: "https://flagcdn.com/w320/qa.png")
        ),
        CountryUIModel(
            id: "SA",
            capital: "Riyadh",countryName: "Qatar",
            currencyName: "Saudi Riyal",
            currencySymbol: "SAR",
            flagURL: URL(string: "https://flagcdn.com/w320/sa.png")
        ),
        CountryUIModel(
            id: "EG",
            capital: "Cairo",countryName: "Qatar",
            currencyName: "Egyptian Pound",
            currencySymbol: "EGP",
            flagURL: URL(string: "https://flagcdn.com/w320/eg.png")
        ),
        CountryUIModel(
            id: "AE",
            capital: "Abu Dhabi",countryName: "Qatar",
            currencyName: "UAE Dirham",
            currencySymbol: "AED",
            flagURL: URL(string: "https://flagcdn.com/w320/ae.png")
        ),
        CountryUIModel(
            id: "KW",
            capital: "Kuwait City",countryName: "Qatar",
            currencyName: "Kuwaiti Dinar",
            currencySymbol: "KWD",
            flagURL: URL(string: "https://flagcdn.com/w320/kw.png")
        )
    ]
    var body: some View {
        NavigationStack {
            List {
                ForEach(mockedCountries) { country in
                    CountryRowView(country: country)
                        .onTapGesture {
                            selectedCountry = country
                        }
                }
                
                .onDelete(perform: delete)
            }
            .navigationTitle("Countires")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedCountry) { country in
                DetailsView(country: country)
            }
        }
    }
    
    private func delete(_ indexSet:IndexSet){
        self.mockedCountries.remove(atOffsets: indexSet)
    }
}

#Preview {
    ContentView()
}


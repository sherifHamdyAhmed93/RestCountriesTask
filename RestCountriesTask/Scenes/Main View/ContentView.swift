//
//  ContentView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCountry: CountryUIModel?
    @StateObject private var viewModel = CountryListViewModel()
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.mainCountries) { country in
                    CountryRowView(country: country)
                        .onTapGesture {
                            selectedCountry = country
                        }
                }
                
                .onDelete(perform: viewModel.deleteCity)
            }
            .navigationTitle("Countires")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedCountry) { country in
                DetailsView(country: country)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(viewModel.mainCountries.count >= 5)
                }
            }
            .task {
                viewModel.loadCountires()
            }
        }
    }
}

#Preview {
    ContentView()
}


//
//  SearchView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.filteredCountries){country in
                Button {
                    viewModel.addCountry(country)
                    dismiss()
                } label: {
                    CountryRowView(country: country)
                }
            }
        }
        .navigationTitle("Search Country")
        .searchable(text: $viewModel.query, prompt: "Search by country name")
        .onDisappear {
            viewModel.query = ""
            viewModel.resetFilteredCountries()
        }
    }
}

#Preview {
    SearchView(viewModel: CountryListViewModel())
}

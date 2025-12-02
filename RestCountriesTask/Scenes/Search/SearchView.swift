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
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack{
            if viewModel.isLoading{
                LoaderView()
            }else if let emptyState = viewModel.emptyState{
                EmptyDataView(emptyState: emptyState)
            }else{
                List {
                    ForEach(viewModel.filteredCountries){country in
                        Button {
                            viewModel.addCountry(country,context: context)
                            dismiss()
                        } label: {
                            CountryRowView(country: country)
                        }
                    }
                }

            }
        }
        .navigationTitle("Search Country")
        .searchable(text: $viewModel.query, prompt: "Search by country name")
        .task {
            viewModel.loadCountires()
        }
        .onDisappear {
            viewModel.onBackFromSearchView()
        }
    }
}

#Preview {
    SearchView(viewModel: CountryListViewModel())
}

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
    @State private var isSearching = false
   
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
        .searchable(text: $viewModel.query,isPresented: $isSearching, prompt: "Search by country name")
        .onChange(of: isSearching) { _, newValue in
            if newValue == false {
                viewModel.cancelSearch()
            }
        }
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

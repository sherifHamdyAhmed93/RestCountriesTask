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
    @Environment(\.modelContext) private var context


    var body: some View {
        NavigationStack {
            VStack{
                 if viewModel.mainCountries.isEmpty{
                    EmptyDataView(emptyState: .noCountries)
                }else{
                    List {
                        ForEach(viewModel.mainCountries) { country in
                            CountryRowView(country: country)
                                .onTapGesture {
                                    selectedCountry = country
                                }
                        }
                        
                        .onDelete { indexSet in
                            viewModel.deleteCity(at: indexSet, context: context)
                        }
                    }
                }
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
                viewModel.fetchLocalCountries(context: context)
            }
        }
    }
}

#Preview {
    ContentView()
        //.modelContainer(for: CountryUIModel.self, inMemory: true)
}


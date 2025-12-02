//
//  CountryListViewModel.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import Foundation
import Combine

final class CountryListViewModel: ObservableObject {
    private(set) var countries: [CountryUIModel] = []
    @Published private(set) var mainCountries:[CountryUIModel] = []
    @Published private(set) var filteredCountries:[CountryUIModel] = []

    @Published private(set) var isLoading:Bool = false
    @Published var query:String = ""
    @Published private(set) var error:String = ""
    @Published private(set) var emptyState:EmptyStateType?

    private let countryService:CountryServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(countryService: CountryServiceProtocol = CountryService()) {
        self.countryService = countryService
        bindSearchQuery()
    }
    
    private func bindSearchQuery(){
        $query
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter {
                $0.isEmpty == false
            }
            .sink { [weak self] country in
                self?.search(for: country)
            }
            .store(in: &cancellables)
    }
    
    func loadCountires() {
        isLoading = true
        countryService.getAllCountries()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion{
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self?.isLoading = false
                    self?.error = error.localizedDescription
                    print("Error : \(error.localizedDescription)")
                }
            } receiveValue: { [weak self]response in
                self?.countries = response.map({
                    CountryUIModel(from: $0)
                })
            }
            .store(in: &cancellables)
    }
    
    func resetFilteredCountries(){
        self.filteredCountries = []
        self.emptyState = nil
    }
    
    private func search(for name:String){
        self.resetFilteredCountries()
        guard !name.isEmpty else{
            self.filteredCountries = self.countries
            return
        }
        let result =  countries.filter { country in
            return country.countryName.lowercased().contains(name.lowercased())
        }
        
        if result.isEmpty{
            emptyState = .noSearchResults
        }
        self.filteredCountries = result
    }
    
    func addCountry(_ country: CountryUIModel) {
        guard mainCountries.count < 5 else { return }
        if !mainCountries.contains(country) {
            mainCountries.append(country)
        }
    }
    
    func onBackFromSearchView(){
        self.resetFilteredCountries()
        self.query = ""
    }
    
    func deleteCity(at offsets: IndexSet) {
        offsets.forEach { index in
            mainCountries.remove(at: index)
        }
    }
    
}

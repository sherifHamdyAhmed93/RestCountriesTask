//
//  CountryListViewModel.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import Foundation
import Combine
import SwiftData

final class CountryListViewModel: ObservableObject {
    private(set) var countries: [CountryUIModel] = []
    @Published private(set) var mainCountries:[CountryUIModel] = []
    @Published private(set) var filteredCountries:[CountryUIModel] = []
    private let locationManager = LocationManager()
    
    @Published private(set) var isLoading:Bool = false
    @Published var query:String = ""
    @Published private(set) var error:String = ""
    @Published private(set) var emptyState:EmptyStateType?
    
    private let countryService:CountryServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var modelContext: ModelContext?

    init(countryService: CountryServiceProtocol = CountryService()) {
        self.countryService = countryService
        bindSearchQuery()
        bindLocation()
    }
    
    //MARK: - Load App data on launch
    ///
    /// - Fetch local countries
    /// - If local countries is empty then fetch from server
    /// - Request access to user location after fetching all countries
    ///
    func loadAppData(context: ModelContext) {
        self.modelContext = context
        fetchLocalCountries(context: context)

        if !mainCountries.isEmpty {
            return
        }

        Task {
            await loadCountires {[weak self] in
                self?.locationManager.requestAccessToLocation()
            }
        }
    }
    
    private func getCountryByCode(countryCode:String){
        guard mainCountries.isEmpty else{return}
        let result =  countries.first { country in
            country.countryCode.caseInsensitiveCompare(countryCode) == .orderedSame
        }
        guard let country = result else{return}
        mainCountries.insert(country, at: 0)
        modelContext?.insert(country)
//        if let index = mainCountries.firstIndex(of: country) {
//            let existing = mainCountries.remove(at: index)
//            mainCountries.insert(existing, at: 0)
//        } else {
//            mainCountries.insert(country, at: 0)
//        }
    }
    
   
    
}

//MARK:- Binding
extension CountryListViewModel{
    func bindLocation(){
        locationManager.countryPublisher
            .first()
            .sink { [weak self] countryCode in
                guard let self else{return}
                self.getCountryByCode(countryCode: countryCode)
            }
            .store(in: &cancellables)
    }
    
    private func bindSearchQuery(){
        $query
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
        //            .filter {
        //                $0.isEmpty == false
        //            }
            .sink { [weak self] country in
                self?.search(for: country)
            }
            .store(in: &cancellables)
    }
    
    
}

//MARK:- Reset search
extension CountryListViewModel{
    func resetFilteredCountries(){
        self.filteredCountries = []
        self.emptyState = nil
    }
    
    func onBackFromSearchView(){
        self.resetFilteredCountries()
        self.query = ""
    }
}

//MARK:- Search
extension CountryListViewModel{
    
    //MARK: - search
    /// search by country name
    ///
    /// - If the search text is empty, all countries are restored.
    /// - If no matching countries are found, the empty state is shown
    /// - if there are a result show filtered Countries
    ///
    /// - Parameter name: The country name  entered by the user.
    private func search(for name: String) {
        self.resetFilteredCountries()
        guard !name.isEmpty else {
            self.filteredCountries = self.countries
            return
        }
        
        let result = countries.filter { country in
            country.countryName.lowercased().contains(name.lowercased())
        }
        
        if result.isEmpty {
            emptyState = .noSearchResults
        }
        
        self.filteredCountries = result
    }
    
    //MARK: - when user cancel search show all countries
    func cancelSearch(){
        self.filteredCountries = self.countries
    }
}


//MARK:- Actions
extension CountryListViewModel{
    //MARK:- Delete country from mainCountries and context
    func deleteCity(at offsets: IndexSet) {
        offsets.forEach { index in
            let country = mainCountries[index]
            self.modelContext?.delete(country)
            mainCountries.remove(at: index)
        }
    }
    
    //MARK:- Add country to mainCountries and context
    func addCountry(_ country: CountryUIModel) {
        guard mainCountries.count < 5 else { return }
        if !mainCountries.contains(country) {
            mainCountries.append(country)
            self.modelContext?.insert(country)
        }
    }
}

extension CountryListViewModel{
    //MARK: - get all countries from api
    @MainActor
    func loadCountires(onFinished: (() -> Void)? = nil){
        guard countries.isEmpty else{return}
        isLoading = true
        countryService.getAllCountries()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion{
                case .finished:
                    print("Finished")
                    onFinished?()
                case .failure(let error):
                    //self?.error = error.localizedDescription
                    self?.emptyState = .error(error.localizedDescription)
                    print("Error : \(error.localizedDescription)")
                    onFinished?()
                }
            } receiveValue: { [weak self]response in
                guard let self else{return}
                self.countries = response.map({
                    CountryUIModel(from: $0)
                })
                self.filteredCountries = self.countries
            }
            .store(in: &cancellables)
    }
    
    //MARK: - fetch countries of main view
    func fetchLocalCountries(context:ModelContext){
        let descriptor = FetchDescriptor<CountryUIModel>(
            sortBy: [SortDescriptor(\.countryName)]
        )
        
        let result = try? context.fetch(descriptor)
        self.mainCountries = result ?? []        
    }
}

//
//  CountryListViewModelTests.swift
//  RestCountriesTaskTests
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import XCTest
import Combine
@testable import RestCountriesTask
import SwiftData

final class CountryListViewModelTests: XCTestCase {
    var viewModel: CountryListViewModel!
    var mockNetwork: MockNetworkService!
    var mockService: CountryServiceProtocol!
    var mockContext: ModelContext!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let container = try? ModelContainer(for: CountryUIModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        mockContext = ModelContext(container!)

        mockNetwork = MockNetworkService()
        mockService = CountryService(networkService: mockNetwork)
        viewModel = CountryListViewModel(countryService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockContext = nil
        cancellables = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoadAppData_WhenMainCountriesNotEmpty_DoesNotFetchFromNetwork() {
        // Given
        mockContext.insert(getMockedUICountries()[0])
        viewModel.fetchLocalCountries(context: mockContext)
        
        // When
        viewModel.loadAppData(context: mockContext)
        
        // Then
        XCTAssertEqual(viewModel.countries.count, 0)
    }
    
    @MainActor
    func testLoadAppData_WhenMainCountriesEmpty_FetchesCountriesAndCallsLocation() async {
        let expectation = XCTestExpectation(description: "Load countries and call location")
        
        viewModel.loadAppData(context: mockContext)
        
        mockNetwork.resultToReturn = .success(getMockedCountries())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertTrue(viewModel.countries.count > 0)
    }
    
    func testDeleteCity_RemovesFromMainCountries() {
        let country = getMockedUICountries()[0]
        viewModel.addCountry(country)
        viewModel.deleteCity(at: IndexSet(integer: 0))
        
        XCTAssertTrue(viewModel.mainCountries.isEmpty)
    }

    
    @MainActor func testLoadCountries_inSuccess_countriesNotEmpty() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        
        let expectation = XCTestExpectation(description: "Countries loaded")
        
        // When
        viewModel.loadCountires {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.countries.count, 2)
        XCTAssertEqual(viewModel.filteredCountries.count, 2)
    }
    
    func testAddCountry_toMainCountries_mainCountriesNoEmpty() {
        // Given
        let country = CountryUIModel(capital: "Doha",
            countryName: "Qatar",
            currencyName: "Qatari Riyal",
            currencySymbol: "QAR",
            flagURL: URL(string: "https://flagcdn.com/w320/qa.png"), countryCode: "EG")
        
        // When
        viewModel.addCountry(country)
        
        // Then
        XCTAssertEqual(viewModel.mainCountries.count, 1)
    }
    
    func testAddCountry_toMainCountries_whenMainCountriesIsFull_mainCountriesNotChanged() {
        // Given
        let mockedCountries = getMockedUICountries()
        for country in mockedCountries {
            viewModel.addCountry(country)
        }
       
        // When
        let country = CountryUIModel(capital: "Doha",
            countryName: "Qatar",
            currencyName: "Qatari Riyal",
            currencySymbol: "QAR",
            flagURL: URL(string: "https://flagcdn.com/w320/qa.png"), countryCode: "EG")
        
        viewModel.addCountry(country)
        
        // Then
        XCTAssertEqual(viewModel.mainCountries.count, 5)
    }
    
    func testAddCountry_toMainCountries_whenCountryIsAddedBefore_mainCountriesNotChanged() {
        // Given
        let mockedCountry = getMockedUICountries()[0]
        viewModel.addCountry(mockedCountry)

       
        // When
        viewModel.addCountry(mockedCountry)
        
        // Then
        XCTAssertEqual(viewModel.mainCountries.count, 1)
    }
    
    @MainActor
    func testSearchCountry_WhenFound_filteredCountriesNotEmpty() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        // When
        let filtered = loadCountriesAndWait(for: "egypt")

        
        // Then
        XCTAssertEqual(filtered.count, 1)
    }
    
    @MainActor
    func testSearchCountry_WhenNotFound_filteredCountriesIsEmpty() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        // When
        let filtered = loadCountriesAndWait(for: "oman")

        
        // Then
        XCTAssertEqual(filtered.count, 0)
    }
    
    @MainActor
    func testSearchCountry_WhenResetSearch_filteredCountriesEqualCountries() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        // When
        let filtered = loadCountriesAndWait(for: "")

        
        // Then
        XCTAssertEqual(filtered.count, viewModel.countries.count)
    }
    
    @MainActor
    func testSearchCountry_WhenNoResult_emptyStateNotNull() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        // When
        let filtered = loadCountriesAndWait(for: "sss")

        
        // Then
        XCTAssertNotNil(viewModel.emptyState)
    }
    
    @MainActor
    func testSearchCountry_WhenResultFound_emptyStateIsNull() {
        // Given
        mockNetwork.resultToReturn = .success(getMockedCountries())
        
        // When
        let filtered = loadCountriesAndWait(for: "Egypt")

        // Then
        XCTAssertNil(viewModel.emptyState)
    }

    @MainActor
    func loadCountriesAndWait(for query: String, timeout: TimeInterval = 2.0) -> [CountryUIModel] {
        let loadExpectation = XCTestExpectation(description: "Load countries")
        viewModel.loadCountires { loadExpectation.fulfill() }
        wait(for: [loadExpectation], timeout: timeout)

        viewModel.query = query
        let searchExpectation = XCTestExpectation(description: "Search debounce")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { searchExpectation.fulfill() }
        wait(for: [searchExpectation], timeout: timeout)

        return viewModel.filteredCountries
    }


    
    private func getMockedCountries()->[CountryResponse]{
        [CountryResponse(
            name: "Egypt",
            capital: "Cairo",
            currencies: [CurrencyResponse(code: "EGP", name: "Egyptian Pound", symbol: "£")],
            flags: FlagResponse(png: ""), alpha2Code: "EG"
        ),
         CountryResponse(
             name: "Qatar",
             capital: "Doha",
             currencies: [CurrencyResponse(code: "QAR", name: "Qatari Riyal", symbol: "£")],
             flags: FlagResponse(png: ""), alpha2Code: "QA"
         )
        ]
    }
    
    private func getMockedUICountries()->[CountryUIModel]{
       [ CountryUIModel(
                    capital: "Doha",countryName: "Qatar",
                    currencyName: "Qatari Riyal",
                    currencySymbol: "QAR",
                    flagURL: URL(string: "https://flagcdn.com/w320/qa.png"),
                    countryCode: "QA"
                ),
                CountryUIModel(
                    capital: "Riyadh",countryName: "Saudi",
                    currencyName: "Saudi Riyal",
                    currencySymbol: "SAR",
                    flagURL: URL(string: "https://flagcdn.com/w320/sa.png"),
                    countryCode: "SA"
                ),
                CountryUIModel(
                    capital: "Cairo",countryName: "Egypt",
                    currencyName: "Egyptian Pound",
                    currencySymbol: "EGP",
                    flagURL: URL(string: "https://flagcdn.com/w320/eg.png"),
                    countryCode: "EG"
                ),
                CountryUIModel(
                    capital: "Abu Dhabi",countryName: "UAE",
                    currencyName: "UAE Dirham",
                    currencySymbol: "AED",
                    flagURL: URL(string: "https://flagcdn.com/w320/ae.png"),
                    countryCode: "AE"
                ),
                CountryUIModel(
                    capital: "Kuwait City",countryName: "Kuwaiti",
                    currencyName: "Kuwaiti Dinar",
                    currencySymbol: "KWD",
                    flagURL: URL(string: "https://flagcdn.com/w320/kw.png"),
                    countryCode: "KW"
                )]
    }
    
}


//
//  CountryServiceTests.swift
//  RestCountriesTaskTests
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import XCTest
@testable import RestCountriesTask
import Combine
final class CountryServiceTests: XCTestCase {
    
    var service: CountryService!
    var networkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        service = CountryService(networkService: networkService)
        cancellables = []
    }
    
    override func tearDown() {
        service = nil
        networkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetAllCountries_inSuccess_dataReturned() {
        // Given
        let expectedCountry = CountryResponse(
            name: "Egypt",
            capital: "Cairo",
            currencies: [CurrencyResponse(code: "EGP", name: "Egyptian Pound", symbol: "£")],
            flags: FlagResponse(png: ""), alpha2Code: "EG"
        )
        
        networkService.resultToReturn = .success([expectedCountry])
        let expectation = self.expectation(description: "Get countries")
        
        var networkResult:[CountryResponse] = []
        
        // When
        service.getAllCountries()
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            } receiveValue: { countries in
                networkResult = countries
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(networkResult.count,1)
        
    }
    
    func testGetAllCountries_inFail_errorReturned() {
        // Given
        let expectedError = URLError(.notConnectedToInternet)
        networkService.resultToReturn = .failure(expectedError)
        let expectation = self.expectation(description: "Get countries failure")
        
        // When
        service.getAllCountries()
            .sink { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected failure, got success")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
}

//
//  MockNetworkService.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import Combine
@testable import RestCountriesTask

final class MockNetworkService: NetworkServiceProtocol {
    var resultToReturn: Result<[CountryResponse], Error>?

    func request<T: Decodable>(_ route: RouteProtocol, type: T.Type) -> AnyPublisher<T, Error>{
        guard let resultToReturn = resultToReturn else {
            return Fail(error: ApiError.serverError(message: "Server Error"))
                .eraseToAnyPublisher()
        }

        switch resultToReturn {
        case .success(let countries):
            if let casted = countries as? T {
                return Just(casted)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: ApiError.decodingError)
                    .eraseToAnyPublisher()
            }
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

//
//  NetworkService.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import Foundation
import Combine

protocol NetworkServiceProtocol{
    func request<T: Decodable>(_ route: RouteProtocol, type: T.Type) -> AnyPublisher<T, Error>
}


final class NetworkService : NetworkServiceProtocol{
    func request<T: Decodable>(_ route: RouteProtocol, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = route.url else {
            return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.networkError
                }
                if httpResponse.statusCode != 200 {
                    if let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        throw ApiError.serverError(message: apiError.message)
                    } else {
                        throw ApiError.serverError(message: "Server returned code: \(httpResponse.statusCode)")
                    }
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return ApiError.decodingError
                } else {
                    return error
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestData(_ route: RouteProtocol) -> AnyPublisher<Data, Error> {
        guard let url = route.url else {
            return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.networkError
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

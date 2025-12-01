//
//  ApiError.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import Foundation
enum ApiError: LocalizedError {
    case invalidURL
    case decodingError
    case serverError(message: String)
    case unknown(Error)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .decodingError:
            return "Failed to decode server response."
        case .serverError(let message):
            return message
        case .networkError:
            return "Check your internet connection and try again"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

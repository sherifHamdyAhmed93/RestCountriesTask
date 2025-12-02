//
//  EmptyStateType.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//

import Foundation

enum EmptyStateType {
    case noCountries
    case noSearchResults

    var title: String {
        switch self {
        case .noCountries:
            return "No Countries Added"
        case .noSearchResults:
            return "No Results Found"
        }
    }

    var description: String {
        switch self {
        case .noCountries:
            return "Start adding countries by tapping the + button.\n\nYou can add up to 5 countries"
        case .noSearchResults:
            return "Try searching with a different country name."
        }
    }
}

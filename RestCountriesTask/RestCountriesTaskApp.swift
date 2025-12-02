//
//  RestCountriesTaskApp.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI
import SwiftData
@main
struct RestCountriesTaskApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: CountryUIModel.self)
        }
    }
}

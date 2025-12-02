//
//  EmptyDataView.swift
//  WeatherAppTask
//
//  Created by Sherif Hamdy on 25/10/2025.
//

import SwiftUI

struct EmptyDataView: View {
    let emptyState:EmptyStateType
    var body: some View {
        VStack(spacing: 10.0){
            if !emptyState.title.isEmpty{
                Text(emptyState.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            
            if !emptyState.description.isEmpty{
                Text(emptyState.description)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.top,55)
        .padding(.bottom,45)
        .padding(.horizontal,30)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.horizontal,30)
    }
}

#Preview {
    EmptyDataView(emptyState: .noCountries)
}

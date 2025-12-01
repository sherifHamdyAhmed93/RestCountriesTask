//
//  CountryInfoView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//

import SwiftUI

struct CountryInfoView: View {
    let capital: String
    let currencyName: String
    var capitalFont: Font = .headline
    var currencyFont: Font = .subheadline
    var capitalColor: Color = .primary
    var currencyColor: Color = .secondary
    var spacing:CGFloat = 5
    var alignment:HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            Text(capital)
                .font(capitalFont)
                .foregroundColor(capitalColor)
            
            Text(currencyName)
                .font(currencyFont)
                .foregroundColor(currencyColor)
        }
    }
}

// MARK: - Preview

struct CountryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
             CountryInfoView(
                capital: "Riyadh",
                currencyName: "Saudi Riyal",
                capitalFont: .title2.bold(),
                currencyFont: .callout,
                capitalColor: .blue,
                currencyColor: .green
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

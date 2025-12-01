//
//  CircularAsyncImage.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 01/12/2025.
//


import SwiftUI

struct CircularAsyncImage: View {
    let url: URL?
    let size: CGFloat

    var body: some View {
        if let url = url {
            AsyncImage(url: url) { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 5)
        } else {
            // Placeholder if URL is nil
            Circle()
                .fill(Color.gray)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 5)
        }
    }
}

// MARK: - Preview
struct CircularAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CircularAsyncImage(url: URL(string: "https://flagcdn.com/w320/eg.png"),
                           size: UIScreen.main.bounds.width / 2)
    }
}

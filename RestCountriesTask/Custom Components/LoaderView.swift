//
//  LoaderView.swift
//  RestCountriesTask
//
//  Created by Sherif Hamdy on 02/12/2025.
//


import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Dim background to block interaction
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color(.systemGreen), lineWidth: 4)
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
        }
        .contentShape(Rectangle())
        .allowsHitTesting(true)
    }
}

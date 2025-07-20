//
//  RandomGradientView.swift
//  Test
//
//  Created by Aitor Sola on 13/7/25.
//

import SwiftUI

struct RandomGradientView: View {
    @State private var colors: [Color] = (0..<3).map { _ in
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1))
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

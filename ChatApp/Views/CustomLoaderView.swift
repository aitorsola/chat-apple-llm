//
//  CustomLoaderView.swift
//  Test
//
//  Created by Aitor Sola on 13/7/25.
//

import SwiftUI

struct CustomLoaderView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.blue, .purple, .blue]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

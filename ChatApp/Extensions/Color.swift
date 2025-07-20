//
//  File.swift
//  ChatApp
//
//  Created by Aitor Sola on 19/7/25.
//

import SwiftUI

extension Color {
    func isLight(threshold: Double = 0.7) -> Bool {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
        return brightness > CGFloat(threshold)

        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
            .usingColorSpace(.deviceRGB) ?? NSColor.white
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
        return brightness > CGFloat(threshold)

        #else
        return true
        #endif
    }
}

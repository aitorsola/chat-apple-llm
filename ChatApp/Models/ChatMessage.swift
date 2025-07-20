//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Aitor Sola on 19/7/25.
//

import Foundation
import SwiftUI

struct ChatMessage: Hashable, Identifiable {
    let id: UUID = UUID()
    let text: String
    let isMachine: Bool
    private let _date = Date()
    let color: Color = Color(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1)
    )
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: _date)
    }
}

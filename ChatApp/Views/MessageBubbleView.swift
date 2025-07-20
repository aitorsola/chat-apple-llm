//
//  MessageBubbleView.swift
//  ChatApp
//
//  Created by Aitor Sola on 19/7/25.
//

import SwiftUI

struct MessageBubbleView: View {
    var message: ChatMessage
    @Binding var glassType: Glass

    #if os(iOS)
    private static let maxBubbleWidth = UIScreen.main.bounds.width * 0.6
    #else
    private static let maxBubbleWidth = 400.0
    #endif

    var body: some View {
        let alignment: HorizontalAlignment = message.isMachine ? .leading : .trailing
        
        VStack(alignment: alignment, spacing: 5) {
            Text(message.text)
                .font(.system(size: message.isMachine ? 16 : 18, design: message.isMachine ? .monospaced : .default))
                .foregroundColor(message.isMachine ? (message.color.isLight() ? .black : .white) : .primary)
                .multilineTextAlignment(message.isMachine ? .leading : .trailing)
            
            Text(message.date)
                .font(.system(size: 11))
                .foregroundColor(message.isMachine ? (message.color.isLight() ? .black : .white) : .secondary)
        }
        .frame(
            maxWidth: Self.maxBubbleWidth,
            alignment: alignment == .leading ? .leading : .trailing
        )
        .padding()
        .glassEffect(message.isMachine ? glassType.tint(message.color.opacity(1)) : glassType, in: .rect)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .contextMenu {
            Button("Copy") {}

            Menu {
                Button("Do this") {}
                Button("Or this") {}
                Button("Or this") {}
            } label: {
                Label("PDF", systemImage: "doc.fill")
            }

            Menu("Actions") {
                Button("Do this") {}
                Button("Or this") {}
                Button("Or this") {}
            }
        }
    }
}

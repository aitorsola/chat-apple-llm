//
//  ChatCellView.swift
//  ChatApp
//
//  Created by Aitor Sola on 20/7/25.
//

import SwiftUI

struct ChatCellView: View {
    let chat: ChatDataSource

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 52, height: 52)
                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)

                Text(chat.id.uuidString.prefix(2))
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Chat \(chat.id.uuidString)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .lineLimit(1)

                if let last = chat.messages.last {
                    Text("💬 \(last.text)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
    }
}

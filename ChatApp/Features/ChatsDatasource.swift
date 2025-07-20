//
//  Untitled.swift
//  ChatApp
//
//  Created by Aitor Sola on 20/7/25.
//

import Combine
import SwiftUI

@MainActor
final class ChatsDataSource: ObservableObject, Identifiable {
    let id: UUID = UUID()
    @Published var chats: [ChatDataSource] = []
    @Published var chatSelected: UUID?
    
    init(loadSample: Bool = true) {
        if loadSample {
            self.loadSample()
        }
    }
    
    @discardableResult
    func new() -> ChatDataSource {
        let newChat = ChatDataSource(loadSample: false, main: self)
        chats.append(newChat)
        chatSelected = newChat.id
        return newChat
    }
    
    func getChat(_ id: UUID) -> ChatDataSource? {
        chats.first(where: { $0.id == id })
    }
    
    func remove(_ id: UUID) {
        chats.removeAll(where: { $0.id == id })
        chatSelected = nil
    }
}

extension ChatsDataSource {
    
    func loadSample() {
        chats.append(ChatDataSource(loadSample: true, main: self))
    }
}

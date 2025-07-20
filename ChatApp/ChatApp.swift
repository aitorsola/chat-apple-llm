//
//  TestApp.swift
//  Test
//
//  Created by Aitor Sola on 12/7/25.
//

import SwiftUI

@main
struct chatApp: App {
    #if os(macOS)
    @StateObject private var observer = WindowObserver()
    #endif
    
    @StateObject private var chatsDataSource = ChatsDataSource(loadSample: true)
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                VStack {
                    HStack {
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: {
                            chatsDataSource.new()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .font(.title3)
                        }
                        .frame(width: 24, height: 24)
                        .padding()
                        .glassEffect()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .overlay(Divider(), alignment: .bottom)
                    
                    if chatsDataSource.chats.isEmpty {
                        Spacer()
                        Text("No chats. \nCreate a new one to continue.")
                            .font(.system(size: 20, design: .monospaced))
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        
                        List(selection: $chatsDataSource.chatSelected) {
                            ForEach(chatsDataSource.chats, id: \.id) { chat in
                                ChatCellView(chat: chat)
                            }
                            .onDelete { chat in
                                chatsDataSource.chats.remove(at: chat.first!)
                            }
                        }
                        .listStyle(.sidebar)
                    }
                }
            } detail: {
                if let chatSelected = chatsDataSource.chatSelected, let chat = chatsDataSource.getChat(chatSelected) {
                    ChatView(chatDatasource: chat)
                }
            }
            .onAppear {
#if os(macOS)
                if let window = NSApplication.shared.windows.first {
                    observer.currentWindow = window
                    window.delegate = observer
                    observer.currentScreen = window.screen
                    observer.updateWindowSize()
                }
#endif
            }
        }
    }
}

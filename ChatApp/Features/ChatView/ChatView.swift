//
//  ChatView.swift
//  Test
//
//  Created by Aitor Sola on 12/7/25.
//

import SwiftUI
import FoundationModels

enum Destination: Hashable {
    case chat(ChatMessage)
}

struct ChatView: View {
    
    var chatDatasource: ChatDataSource
        
    @State private var path: NavigationPath = NavigationPath()
    @State private var prompt: String = ""
    @State private var glassType: Glass  = .clear
    
#if os(iOS)
    @StateObject private var keyboard = KeyboardObserver.shared
#endif

    var body: some View {
        var temperatureToolbarPlacement: ToolbarItemPlacement {
            #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
            return .topBarTrailing
            #else
            return .principal
            #endif
        }
        
        var utilsToolbarPlacement: ToolbarItemPlacement {
            #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
            return .topBarLeading
            #else
            return .automatic
            #endif
        }
        
        NavigationStack(path: $path) {
            Group {
                if chatDatasource.chatIsAvailable() {
                    ZStack {
                        if chatDatasource.messages.isEmpty {
                            Spacer()
                            
                            Text("Start\nchatting")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 30, weight: .bold, design: .monospaced))
                                .padding()
                            
                            Spacer()
                        } else {
                            ScrollViewReader { proxy in
                                ScrollView(.vertical) {
                                    LazyVGrid(columns: [GridItem()]) {
                                        ForEach(Array(chatDatasource.messages.enumerated()), id: \.offset) { index, chat in
                                            HStack {
                                                if chat.isMachine {
                                                    MessageBubbleView(message: chat, glassType: $glassType)
                                                    Spacer()
                                                } else {
                                                    Spacer()
                                                    MessageBubbleView(message: chat, glassType: $glassType)
                                                }
                                            }
                                            .contentShape(Rectangle())
                                            .id(index)
                                            .onTapGesture { path.append(Destination.chat(chat)) }
                                        }
                                    }
                                    .padding([.leading, .trailing])
#if os(iOS)
                                    .padding(.bottom, keyboard.isKeyboardVisible ? 70 : 55)
#else
                                    .padding(.bottom, 70)
#endif
                                }
                                .scrollDismissesKeyboard(.interactively)
                                .onChange(of: chatDatasource.messages, { _, _ in
                                    scrollToBottom(proxy)
                                })
                                .onAppear {
                                    scrollToBottom(proxy)
                                }
                                .navigationTitle("Chat")
                                .scrollIndicators(.hidden)
#if os(iOS)
                                .navigationBarTitleDisplayMode(.inline)
#endif
                                .scrollContentBackground(.hidden)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            
                            TextField("Ask something...", text: $prompt)
                                .frame(height: 50)
                                .padding(.leading, 8)
                                .autocorrectionDisabled()
#if os(iOS)
                                .textInputAutocapitalization(.sentences)
                                .glassEffect(glassType)
#endif
                                .foregroundStyle(Color.primary)
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .onSubmit { send() }
                            
                            Button {
                                send()
                            } label: {
                                if chatDatasource.session.isResponding {
                                    CustomLoaderView()
                                        .frame(width: 20, height: 20)
                                        .padding(10)
                                        .glassEffect(glassType)
                                } else {
                                    Image(systemName: "arrow.up.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(10)
                                        .tint(Color.primary)
                                        .glassEffect(glassType)
                                }
                            }
                            .tint(.clear)
                        }
                        .padding([.leading, .trailing], 20)
#if os(iOS)
                        .padding(.bottom, keyboard.isKeyboardVisible ? 8 : -8)
#else
                        .padding(.bottom)
#endif
                        .ignoresSafeArea(.keyboard)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .background {
                        RandomGradientView()
                    }
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .chat(let response):
                            Text(response.text)
                                .navigationTitle("Response")
                                .padding()
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: temperatureToolbarPlacement) {
                            Button(glassType == .regular ? "❄️" : "🥃") {
                                glassType = glassType == .regular ? .clear : .regular
                            }
                            .font(.system(size: 30))
                            
                            if !chatDatasource.messages.isEmpty {
                                Button("", systemImage: "trash.fill") {
                                    guard !chatDatasource.session.isResponding else { return }
                                    self.prompt = ""
                                    self.chatDatasource.clear()
                                }
                                .tint(Color.primary)
                            }
                        }
                        
                        /* ToolbarItemGroup(placement: utilsToolbarPlacement) {
                            Slider(value: $chatDatasource.temperature, in: 0...2)
                                .frame(width: 100)
                                .tint(Color.primary)
                                .padding()
                        }*/
                    }
                } else {
                    Spacer()
                    Text("LLM not available here :(")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .padding()
                    Spacer()
                }
            }
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(.easeInOut) {
            proxy.scrollTo(chatDatasource.messages.count - 1, anchor: .zero)
        }
    }
    
    private func send() {
            guard !chatDatasource.session.isResponding, !prompt.isEmpty else { return }
            let prompt = self.prompt
            self.prompt = ""
            Task {
                await chatDatasource.send(prompt)
            }
    }
}

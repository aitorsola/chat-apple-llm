//
//  KeyboardObserver.swift
//  Test
//
//  Created by Aitor Sola on 19/7/25.
//


import SwiftUI
import Combine

#if os(iOS)
final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = KeyboardObserver()
    
    private init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        
        Publishers.Merge(willShow, willHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
#endif

//
//  WindowObserver.swift
//  Test
//
//  Created by Aitor Sola on 13/7/25.
//

#if os(macOS)
import AppKit
import Combine


class WindowObserver: NSObject, ObservableObject, NSWindowDelegate {
    @Published var currentScreen: NSScreen?
    var currentWindow: NSWindow?

    private var cancellable: AnyCancellable?

    override init() {
        super.init()
        cancellable = NotificationCenter.default.publisher(for: NSWindow.didChangeScreenNotification)
            .compactMap { $0.object as? NSWindow }
            .sink { [weak self] window in
                DispatchQueue.main.async {
                    self?.currentWindow = window
                    self?.currentScreen = window.screen
                    // No actualices tamaño aquí, espera a terminar mover/redimensionar
                }
            }
    }

    func windowDidEndLiveResize(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              window == currentWindow else { return }
        
        currentScreen = window.screen
        updateWindowSize()
    }

    func updateWindowSize() {
        guard let screenFrame = currentScreen?.visibleFrame,
              let window = currentWindow else { return }

        let isPortrait = screenFrame.height > screenFrame.width

        let newWidth = isPortrait ? screenFrame.width * 0.6 : screenFrame.width * 0.4
        let newHeight = isPortrait ? screenFrame.height * 0.4 : screenFrame.height * 0.6

        var frame = window.frame
        frame.size = CGSize(width: newWidth, height: newHeight)

        frame.origin.x = screenFrame.origin.x + (screenFrame.width - newWidth) / 2
        frame.origin.y = screenFrame.origin.y + (screenFrame.height - newHeight) / 2

        window.setFrame(frame, display: true, animate: false)
    }
}
#endif

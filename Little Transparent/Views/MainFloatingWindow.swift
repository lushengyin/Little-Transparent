import SwiftUI

class MainFloatingWindow: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
                .nonactivatingPanel,
                .fullSizeContentView,
            ],
            backing: .buffered,
            defer: false
        )

        isFloatingPanel = true
        level = .floating
        becomesKeyOnlyIfNeeded = true
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        isMovableByWindowBackground = true
        isOpaque = false
        backgroundColor = .clear
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        hasShadow = true

        // Allow keyboard input despite nonactivating
        styleMask.insert(.nonactivatingPanel)
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

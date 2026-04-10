import SwiftUI

enum WindowLevel: Int, CaseIterable {
    case normal = 0
    case floating = 1
    case topmost = 2

    var label: String {
        switch self {
        case .normal: return "普通"
        case .floating: return "浮动"
        case .topmost: return "置顶"
        }
    }

    var nsWindowLevel: NSWindow.Level {
        switch self {
        case .normal: return .normal
        case .floating: return .floating
        case .topmost: return .screenSaver
        }
    }

    var icon: String {
        switch self {
        case .normal: return "arrow.down.to.line"
        case .floating: return "arrow.up.to.line"
        case .topmost: return "pin"
        }
    }
}

class WindowConfig: ObservableObject {
    @Published var opacity: Double = 1.0 {
        didSet { syncToWindow() }
    }
    @Published var windowLevel: WindowLevel = .floating {
        didSet { syncLevelToWindow() }
    }

    init() {
        load()
    }

    private func syncToWindow() {
        DispatchQueue.main.async {
            for window in NSApp.windows where window.isVisible {
                window.alphaValue = CGFloat(self.opacity)
            }
        }
    }

    private func syncLevelToWindow() {
        DispatchQueue.main.async {
            for window in NSApp.windows where window.isVisible {
                window.level = self.windowLevel.nsWindowLevel
            }
        }
    }

    func configureInitialWindow() {
        DispatchQueue.main.async {
            for window in NSApp.windows where window.isVisible {
                window.isOpaque = false
                window.backgroundColor = .clear
                window.hasShadow = true
                window.alphaValue = CGFloat(self.opacity)
                window.level = self.windowLevel.nsWindowLevel
            }
        }
    }

    func save() {
        UserDefaults.standard.set(opacity, forKey: "windowOpacity")
        UserDefaults.standard.set(windowLevel.rawValue, forKey: "windowLevel")
    }

    func load() {
        let savedOpacity = UserDefaults.standard.object(forKey: "windowOpacity") as? Double ?? 1.0
        let levelRaw = UserDefaults.standard.integer(forKey: "windowLevel")
        let savedLevel = WindowLevel(rawValue: levelRaw) ?? .floating

        // Direct assignment - didSet will fire but NSApp.windows is empty during init, so syncToWindow is a no-op
        opacity = savedOpacity
        windowLevel = savedLevel
    }
}

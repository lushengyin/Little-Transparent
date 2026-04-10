import AppKit

enum WindowLevelHelper {
    static func applyLevel(_ level: WindowLevel, to window: NSWindow?) {
        guard let window = window else { return }
        window.level = level.nsWindowLevel
    }
}

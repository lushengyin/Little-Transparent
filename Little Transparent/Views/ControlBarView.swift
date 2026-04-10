import SwiftUI

struct ControlBarView: View {
    @ObservedObject var windowConfig: WindowConfig

    var body: some View {
        HStack(spacing: 8) {
            // Opacity control
            Image(systemName: "circle.lefthalf.filled")
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Slider(value: $windowConfig.opacity, in: 0.05...1.0, step: 0.05)
                .frame(maxWidth: 100)
                .onChange(of: windowConfig.opacity) { _ in
                    windowConfig.save()
                }

            Text("\(Int(windowConfig.opacity * 100))%")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(width: 32, alignment: .trailing)

            Divider()
                .frame(height: 14)

            // Window level control
            ForEach(WindowLevel.allCases, id: \.self) { level in
                Button(action: {
                    windowConfig.windowLevel = level
                    windowConfig.save()
                    NotificationCenter.default.post(name: .windowLevelDidChange, object: level)
                }) {
                    Image(systemName: level.icon)
                        .font(.system(size: 11))
                        .foregroundColor(windowConfig.windowLevel == level ? .accentColor : .secondary)
                }
                .buttonStyle(.plain)
                .help(level.label)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(nsColor: .controlBackgroundColor).opacity(0.8))
        )
    }
}

extension Notification.Name {
    static let windowLevelDidChange = Notification.Name("windowLevelDidChange")
}

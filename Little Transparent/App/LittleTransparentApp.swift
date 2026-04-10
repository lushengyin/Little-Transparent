import SwiftUI

@main
struct LittleTransparentApp: App {
    @StateObject private var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainWindowView(viewModel: viewModel)
                .onAppear {
                    viewModel.loadTabs()
                    viewModel.windowConfig.configureInitialWindow()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 480, height: 360)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("添加标签") {
                    viewModel.showAddSheet = true
                }
                .keyboardShortcut("n", modifiers: .command)
            }

            CommandGroup(after: .toolbar) {
                Button("增加透明度") {
                    viewModel.windowConfig.opacity = min(1.0, viewModel.windowConfig.opacity + 0.05)
                    viewModel.windowConfig.save()
                }
                .keyboardShortcut("+", modifiers: .command)

                Button("降低透明度") {
                    viewModel.windowConfig.opacity = max(0.05, viewModel.windowConfig.opacity - 0.05)
                    viewModel.windowConfig.save()
                }
                .keyboardShortcut("-", modifiers: .command)

                Divider()

                Button("切换层级") {
                    viewModel.windowConfig.windowLevel = WindowLevel(rawValue: (viewModel.windowConfig.windowLevel.rawValue + 1) % WindowLevel.allCases.count) ?? .floating
                    viewModel.windowConfig.save()
                }
                .keyboardShortcut("l", modifiers: .command)
            }
        }
    }
}

import SwiftUI

struct MainWindowView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Control bar at top
            ControlBarView(windowConfig: viewModel.windowConfig)
                .padding(.top, 4)
                .padding(.horizontal, 4)

            // Content area
            Group {
                if let tab = viewModel.activeTab {
                    tabContent(for: tab)
                        .id(tab.id)
                } else {
                    emptyState
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab bar at bottom
            TabBarView(viewModel: viewModel)
                .padding(.bottom, 4)
                .padding(.horizontal, 4)
        }
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddTabSheet(viewModel: viewModel)
        }
    }

    @ViewBuilder
    private func tabContent(for tab: TabItem) -> some View {
        switch tab.type {
        case .web:
            if let url = tab.url {
                WebViewContainer(url: url, contentType: .web, windowConfig: viewModel.windowConfig)
            }
        case .txt:
            if let url = tab.url {
                WebViewContainer(url: url, contentType: .txt, windowConfig: viewModel.windowConfig)
            }
        case .epub:
            if let url = tab.url {
                WebViewContainer(url: url, contentType: .epub, windowConfig: viewModel.windowConfig)
            }
        case .video:
            if let url = tab.url {
                VideoPlayerView(url: url)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle")
                .font(.system(size: 32))
                .foregroundColor(.secondary)
            Text("点击 + 添加内容")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("添加标签") {
                viewModel.showAddSheet = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.wantsLayer = true
        view.layer?.cornerRadius = 10
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

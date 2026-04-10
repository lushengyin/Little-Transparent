import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        HStack(spacing: 4) {
            // Existing tabs
            ForEach(viewModel.tabs) { tab in
                TabButton(
                    tab: tab,
                    isActive: tab.id == viewModel.activeTabId,
                    onSelect: { viewModel.selectTab(id: tab.id) },
                    onClose: { viewModel.removeTab(id: tab.id) }
                )
            }

            // Add tab button
            Button(action: {
                viewModel.showAddSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .help("添加标签")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

struct TabButton: View {
    let tab: TabItem
    let isActive: Bool
    let onSelect: () -> Void
    let onClose: () -> Void

    var icon: String {
        switch tab.type {
        case .web: return "globe"
        case .txt: return "doc.text"
        case .epub: return "book"
        case .video: return "play.rectangle"
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(tab.title)
                .font(.system(size: 11))
                .lineLimit(1)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isActive ? Color.accentColor.opacity(0.5) : Color.secondary.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture { onSelect() }
    }
}

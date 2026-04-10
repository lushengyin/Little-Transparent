import SwiftUI
import UniformTypeIdentifiers

struct AddTabSheet: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var urlString: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            Text("添加新标签")
                .font(.headline)

            // Web URL input
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.secondary)
                TextField("输入网址", text: $urlString)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { addWebTab() }

                Button("打开") { addWebTab() }
                    .disabled(urlString.isEmpty)
            }

            Divider()

            // File open buttons
            HStack(spacing: 16) {
                FileOpenButton(icon: "doc.text", label: "文本文件") {
                    openFile(allowedTypes: [.plainText])
                }
                FileOpenButton(icon: "book", label: "EPUB") {
                    openFile(allowedTypes: [UTType(filenameExtension: "epub") ?? .data])
                }
                FileOpenButton(icon: "play.rectangle", label: "视频文件") {
                    openFile(allowedTypes: [.movie, .mpeg4Movie, .quickTimeMovie])
                }
            }

            Button("取消") { dismiss() }
                .keyboardShortcut(.cancelAction)
        }
        .padding(20)
        .frame(width: 360)
    }

    private func addWebTab() {
        var urlStr = urlString.trimmingCharacters(in: .whitespaces)
        if !urlStr.isEmpty && !urlStr.hasPrefix("http") {
            urlStr = "https://" + urlStr
        }
        guard let url = URL(string: urlStr), let host = url.host else { return }
        let tab = TabItem(title: host, type: .web, url: url)
        viewModel.addTab(tab)
        dismiss()
    }

    private func openFile(allowedTypes: [UTType]) {
        // Dismiss the SwiftUI sheet first, then show NSOpenPanel
        // to avoid nested modal conflict
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            FileOpener.openFile(allowedTypes: allowedTypes) { fileURL, contentType in
                DispatchQueue.main.async {
                    let title = fileURL.deletingPathExtension().lastPathComponent
                    let tab = TabItem(title: title, type: contentType, url: fileURL)
                    viewModel.addTab(tab)
                }
            }
        }
    }
}

struct FileOpenButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
}

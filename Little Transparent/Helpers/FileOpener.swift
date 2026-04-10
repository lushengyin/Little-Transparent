import AppKit
import UniformTypeIdentifiers

enum FileOpener {
    struct FileType {
        let type: ContentType
        let utTypes: [UTType]
        let label: String
    }

    static let supportedTypes: [FileType] = [
        FileType(type: .txt, utTypes: [.plainText], label: "文本文件"),
        FileType(type: .epub, utTypes: [UTType(filenameExtension: "epub") ?? .data], label: "EPUB 电子书"),
        FileType(type: .video, utTypes: [.movie, .mpeg4Movie, .quickTimeMovie], label: "视频文件"),
    ]

    /// Opens a file panel asynchronously using beginSheetModal.
    /// This avoids the modal conflict that occurs with runModal() inside SwiftUI sheets.
    static func openFile(allowedTypes: [UTType] = [.plainText, .movie, .mpeg4Movie, .quickTimeMovie], completion: @escaping (URL, ContentType) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = allowedTypes

        panel.begin { response in
            panel.close()
            guard response == .OK, let url = panel.url else { return }
            let contentType = detectContentType(url: url)
            completion(url, contentType)
        }
    }

    static func detectContentType(url: URL) -> ContentType {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "txt", "md", "log":
            return .txt
        case "epub":
            return .epub
        case "mp4", "mov", "avi", "mkv", "m4v", "webm":
            return .video
        default:
            return .web
        }
    }
}

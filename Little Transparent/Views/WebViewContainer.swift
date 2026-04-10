import SwiftUI
import WebKit

struct WebViewContainer: NSViewRepresentable {
    let url: URL
    let contentType: ContentType
    @ObservedObject var windowConfig: WindowConfig

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.isElementFullscreenEnabled = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.setValue(false, forKey: "drawsBackground")
        webView.navigationDelegate = context.coordinator
        webView.translatesAutoresizingMaskIntoConstraints = false

        switch contentType {
        case .web, .epub:
            let request = URLRequest(url: url)
            webView.load(request)
        case .txt:
            loadTxtFile(url: url, into: webView)
        case .video:
            break
        }

        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        // No-op: URL changes create a new WebView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }

    private func loadTxtFile(url: URL, into webView: WKWebView) {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }

        let escapedContent = content
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\n", with: "<br>")
            .replacingOccurrences(of: "  ", with: "&nbsp;&nbsp;")

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <style>
            body {
                font-family: -apple-system, "PingFang SC", sans-serif;
                font-size: 16px;
                line-height: 1.8;
                color: #333;
                padding: 20px;
                margin: 0;
                background: transparent;
                -webkit-user-select: text;
            }
        </style>
        </head>
        <body>\(escapedContent)</body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}

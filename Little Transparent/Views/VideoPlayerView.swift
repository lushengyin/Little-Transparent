import SwiftUI
import AVKit

struct VideoPlayerView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> AVPlayerView {
        let playerView = AVPlayerView()
        playerView.player = AVPlayer(url: url)
        playerView.controlsStyle = .inline
        playerView.player?.play()
        return playerView
    }

    func updateNSView(_ playerView: AVPlayerView, context: Context) {}
}

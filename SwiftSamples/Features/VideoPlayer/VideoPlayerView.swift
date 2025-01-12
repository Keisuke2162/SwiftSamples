import AVKit
import SwiftUI

/// 動画プレイヤー

@MainActor
public class VideoPlayerViewModel: ObservableObject {
  @Published var player: AVPlayer

  public init(vieoURL: URL) {
    self.player = AVPlayer(url: vieoURL)
  }
}

public struct VideoPlayerView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var viewModel: VideoPlayerViewModel

  public init(viewModel: VideoPlayerViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      VideoPlayer(player: viewModel.player) {
        VStack {
          HStack {
            Spacer()
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .padding(16)
            }
          }
          Spacer()
        }
      }
      .onAppear {
        viewModel.player.play()
      }
      .onDisappear {
        viewModel.player.pause()
      }
    }
  }
}

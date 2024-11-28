import Foundation
import Dependencies
import SwiftUI
import Kingfisher

@MainActor
public class VideoGridViewModel: ObservableObject {
  @Published var videoItems: [VideoItem] = []
  @Published var errorMessage: String = ""
  @Published var selectVideoItem: VideoFileItem?
  
  @Dependency(\.videoAPIClient) private var videoAPIClient

  func fetchVideoItems() async {
    do {
      videoItems = try await videoAPIClient.fetchPopularVideos()
      errorMessage = ""
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func onTapGridItem(videoItem: VideoItem) {
    selectVideoItem = videoItem.videoFiles.last
  }
}

public struct VideoGridView: View {
  @StateObject private var viewModel: VideoGridViewModel

  init(viewModel: VideoGridViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(viewModel.videoItems) { item in
          Button {
            viewModel.onTapGridItem(videoItem: item)
          } label: {
            ZStack {
              KFImage(item.videoPictures.last?.picture)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipped()
              Image(systemName: "play.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.black.opacity(0.8))
            }
          }
        }
      }
      .padding(.horizontal, 8)
    }
    .onAppear {
      Task {
        await viewModel.fetchVideoItems()
      }
    }
    .fullScreenCover(item: $viewModel.selectVideoItem) { item in
      VideoPlayerView(viewModel: VideoPlayerViewModel(vieoURL: item.link))
    }
  }
}

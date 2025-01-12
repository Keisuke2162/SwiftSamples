import Dependencies
import Foundation

public protocol VideoAPIClientProtocol: Sendable {
  func fetchPopularVideos() async throws -> [VideoItem]
}

public struct VideoAPIClient: VideoAPIClientProtocol {
  public init() {
  }

  public func fetchPopularVideos() async throws -> [VideoItem] {
    // let baseAPIURL: URL = URL(string: "https://api.pexels.com/videos/popular")!
    guard let fileURL = Bundle.main.url(forResource: "popular_videos", withExtension: "json") else {
      throw VideoAPIError.notJsonFile
    }

    let data = try Data(contentsOf: fileURL)
    do {
      let item = try JSONDecoder().decode(VideoResponse.self, from: data)
      let videoItems = item.videos
      return videoItems
    } catch {
      throw VideoAPIError.encodeError
    }
  }
  
  enum VideoAPIError: Error {
    case noData
    case notJsonFile
    case invalidURL
    case encodeError
  }
}

private enum VideoAPIClientKey: DependencyKey {
  static let liveValue: any VideoAPIClientProtocol = VideoAPIClient()
}

extension DependencyValues {
  public var videoAPIClient: any VideoAPIClientProtocol {
    get { self[VideoAPIClientKey.self] }
    set { self[VideoAPIClientKey.self] = newValue }
  }
}

import Foundation

public struct VideoResponse: Codable {
  let videos: [VideoItem]
}

public struct VideoItem: Codable, Identifiable {
  public let id: Int
  let duration: Int
  let videoFiles: [VideoFileItem]
  let videoPictures: [VideoPicture]
  

  enum CodingKeys: String, CodingKey {
    case id, duration
    case videoFiles = "video_files"
    case videoPictures = "video_pictures"
  }
}

public struct VideoFileItem: Codable, Identifiable {
  public let id: Int
  let link: URL
}

public struct VideoPicture: Codable {
  let id: Int
  let picture: URL
}

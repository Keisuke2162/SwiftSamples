import Foundation

struct SNSPost: Codable, Identifiable {
  let id = UUID()
  let postText: String?
  let postImageURL: String?
  let createdAt: Date

  // TODO: そのうちuserIDのみにしてタイムライン取得時にUserIDから名前とサムネイル取得するようにしたい
  let userID: String
  let userName: String
  let userProfileImageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case postText
    case postImageURL
    case createdAt
    case userID
    case userName
    case userProfileImageURL
  }
}

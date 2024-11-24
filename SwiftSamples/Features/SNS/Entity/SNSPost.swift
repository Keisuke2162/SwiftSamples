import Foundation

struct SNSPost: Codable {
  let postText: String?
  let postImageURL: String?
  let createdAt: Date

  let userID: String
  
  enum CodingKeys: String, CodingKey {
    case postText
    case postImageURL
    case createdAt
    case userID
  }
}

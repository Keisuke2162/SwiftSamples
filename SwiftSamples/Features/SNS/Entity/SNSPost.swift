import Foundation

struct SNSPost {
  let postText: String?
  let postImageURL: String?
  let createdAt: Date

  // TODO: そのうちuserIDのみにしてタイムライン取得時にUserIDから名前とサムネイル取得するようにしたい
  let userID: String
  let userName: String
  let userProfileImageURL: String
}

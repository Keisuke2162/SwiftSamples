import Foundation
import FirebaseFirestore
// MEMO: userIDに@DocumentID使いたかったけどうまくデコードできなかった

struct SNSUser: Codable {
  var userID: String = ""
  let userName: String
  let userProfileImageURL: URL?

  enum CodingKeys: String, CodingKey {
    case userName = "name"
    case userProfileImageURL = "thumbnailURL"
  }
}

import Foundation

struct SNSTimelineItem: Identifiable {
  let id = UUID()
  let post: SNSPost
  let user: SNSUser
}

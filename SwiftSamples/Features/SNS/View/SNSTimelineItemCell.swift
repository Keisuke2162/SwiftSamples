import Kingfisher
import SwiftUI

public struct SNSTimelineItemCell: View {
  private let item: SNSTimelineItem
  
  init(item: SNSTimelineItem) {
    self.item = item
  }

  public var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 16) {
        KFImage(item.user.userProfileImageURL)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 48, height: 48)
          .clipShape(Circle())
        Text(item.user.userName)
      }
      .padding(.top, 16)
      .padding(.horizontal, 16)
      KFImage(URL(string: item.post.postImageURL ?? ""))
        .resizable()
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .clipped()
      HStack {
        Spacer()
        Text(item.post.createdAt.toString())
          .font(.caption)
          .foregroundStyle(Color.gray.opacity(0.9))
      }
      .padding(.horizontal, 16)
      Text(item.post.postText ?? "")
        .padding(.horizontal, 16)
      Color.gray.opacity(0.3)
        .frame(height: 1)
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
  }
}

import SwiftUI
import Kingfisher
import FirebaseStorage
import FirebaseFirestore

@MainActor
public class SNSTimelineViewModel: ObservableObject {
  @Published var timelineItems: [SNSTimelineItem] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String = ""

  func onAppear() async {
    isLoading = true

    let postList = await fetchPostsData()
    let postUserIDs = Array(Set(postList.map { $0.userID }))
    let userList = await fetchUserData(userIDs: postUserIDs)
    timelineItems = createTimelineItems(posts: postList, users: userList)

    isLoading = false
  }
  
  private func createTimelineItems(posts: [SNSPost], users: [SNSUser]) -> [SNSTimelineItem] {
    // SNSUser.userID: SNSUser の形の辞書型を作る
    let userDict = Dictionary(uniqueKeysWithValues: users.map { ($0.userID, $0) })
    // postsのuserIDに対応するUserを取得してSNSTimelineItemを作る
    return posts.compactMap { post in
      guard let user = userDict[post.userID] else { return nil }
      return SNSTimelineItem(post: post, user: user)
    }
  }

  private func fetchPostsData() async -> [SNSPost] {
    do {
      let querySnapshot = try await Firestore.firestore()
        .collection("posts")
        .order(by: "createdAt", descending: true)
        .limit(to: 20)
        .getDocuments()
      let postData = querySnapshot.documents.compactMap { document in
        try? document.data(as: SNSPost.self)
      }
      return postData
    } catch {
      errorMessage = "Failed fetch timeline data \(error.localizedDescription)"
      return []
    }
  }

  // userIDの一覧からユーザー情報を取得（一気に取得できるのは10ユーザーまでっぽいので注意）
  private func fetchUserData(userIDs: [String]) async -> [SNSUser] {
    do {
      let querySnapshot = try await Firestore.firestore()
        .collection("users")
        .whereField(FieldPath.documentID(), in: userIDs)
        .getDocuments()
      return querySnapshot.documents.compactMap { document in
        var user = try? document.data(as: SNSUser.self)
        user?.userID = document.documentID
        return user
      }
    } catch {
      errorMessage = "Failed fetch users data \(error.localizedDescription)"
      return []
    }
  }
}

public struct SNSTimelineView: View {
  @StateObject private var viewModel: SNSTimelineViewModel
  
  public init(viewModel: SNSTimelineViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      ScrollView {
        ForEach(viewModel.timelineItems) { item in
          SNSTimelineItemCell(item: item)
        }
      }
      if viewModel.isLoading {
        SNSLoadingView()
      }

      if !viewModel.errorMessage.isEmpty {
        Color.red.opacity(0.3)
          .background(ignoresSafeAreaEdges: .bottom)
        Text(viewModel.errorMessage)
          .font(.title)
          .padding()
          .background(Color.red)
          .foregroundStyle(Color.white)
      }
    }
    .onAppear {
      Task {
        await viewModel.onAppear()
      }
    }
  }
}

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

@MainActor
public class SNSTimelineViewModel: ObservableObject {
  @Published var posts: [SNSPost] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String = ""

  func onAppear() async {
    isLoading = true
    do {
      let querySnapshot = try await Firestore.firestore()
        .collection("posts")
        .order(by: "createdAt", descending: true)
        .limit(to: 20)
        .getDocuments()
      let postData = querySnapshot.documents.compactMap { document in
        try? document.data(as: SNSPost.self)
      }
      posts = postData
    } catch {
      errorMessage = "Failed fetch timeline data \(error.localizedDescription)"
    }
    isLoading = false
  }
}

public struct SNSTimelineView: View {
  @StateObject private var viewModel: SNSTimelineViewModel
  
  public init(viewModel: SNSTimelineViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      List {
        ForEach(viewModel.posts) { post in
          Text(post.postText ?? "")
        }
      }

      if viewModel.isLoading {
        SNSLoadingView()
      }
    }
    .onAppear {
      Task {
        await viewModel.onAppear()
      }
    }
  }
}

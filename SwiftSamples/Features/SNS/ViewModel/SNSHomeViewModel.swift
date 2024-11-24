import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
public class SNSHomeViewModel: ObservableObject {
  @Published var isShowSignInView = false
  @Published var isLoading = false
  @Published var errorMessage = ""

  // ユーザー情報
  private let db = Firestore.firestore()
  @Published var snsUser: SNSUser?
//  @Published var userID: String = ""
//  @Published var userName: String = ""
//  @Published var profileImageURL: URL?

  public init() {
  }

  func onAppear() async {
    await login()
  }

  func onLoggedIn() {
    isShowSignInView = false

    Task {
      await login()
    }
  }

  private func login() async {
    isLoading = true
    // ログイン処理
    guard let currentUser = Auth.auth().currentUser else {
      // アカウントがなければサインイン画面に遷移
      isLoading = false
      isShowSignInView = true
      return
    }
    // プロフィール取得
    let docRef = db.collection("users").document(currentUser.uid)
    do {
      let document = try await docRef.getDocument()
      guard let data = document.data() else {
        isLoading = false
        isShowSignInView = true
        errorMessage = "User data not found"
        return
      }
      let userName = data["name"] as? String ?? ""
      let profileImageURL = URL(string: data["thumbnailURL"] as? String ?? "")

      self.snsUser = .init(
        userID: currentUser.uid,
        userName: userName,
        userProfileImageURL: profileImageURL
      )
    } catch {
      isLoading = false
      isShowSignInView = true
      errorMessage = "Failed GET User data"
    }

    isLoading = false
  }

  func logout() {
    do {
      try Auth.auth().signOut()
    } catch {
      // ログアウト失敗
    }
    snsUser = nil
    isShowSignInView = true
  }
}

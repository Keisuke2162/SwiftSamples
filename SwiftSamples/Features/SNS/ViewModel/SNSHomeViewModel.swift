import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
public class SNSHomeViewModel: ObservableObject {
  @Published var isLoggedIn = false
  @Published var isShowSignInView = false
  @Published var isLoading = false
  @Published var errorMessage = ""

  // ユーザー情報
  private let db = Firestore.firestore()
  @Published var userName: String = ""
  @Published var profileImageURL: URL?

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
    // ログイン処理
    guard let currentUser = Auth.auth().currentUser else {
      // アカウントがなければサインイン画面に遷移
      isShowSignInView = true
      return
    }
    // プロフィール取得
    let docRef = db.collection("users").document(currentUser.uid)
    do {
      let document = try await docRef.getDocument()
      guard let data = document.data() else {
        errorMessage = "User data not found"
        return
      }

      self.userName = data["name"] as? String ?? ""
      self.profileImageURL = URL(string: data["thumbnailURL"] as? String ?? "")
    } catch {
      errorMessage = "Failed GET User data"
    }

    isLoggedIn = true
  }

  func logout() {
    do {
      try Auth.auth().signOut()
    } catch {
      // ログアウト失敗
    }
    isLoggedIn = false
    isShowSignInView = true
  }
}

import Foundation
import FirebaseAuth

@MainActor
public class SNSHomeViewModel: ObservableObject {
  @Published var isLoggedIn = false
  @Published var isShowSignInView = false

  public init() {
  }

  func onAppear() {
    // ログイン処理
    guard let currentUser = Auth.auth().currentUser else {
      // アカウントがなければサインイン画面に遷移
      isShowSignInView = true
      return
    }
    // ログイン完了
    isLoggedIn = true
  }
  
  func onLoggedIn() {
    // サインイン画面を閉じる
    isShowSignInView = false
    
    // 再度ログイン処理を行う
    guard let currentUser = Auth.auth().currentUser else {
      // アカウントがなければサインイン画面に遷移
      isShowSignInView = true
      return
    }

    // ログイン完了
    isLoggedIn = true
  }

  func logout() {
    do {
      try Auth.auth().signOut()
    } catch {
      // ログアウト失敗
    }
    // ログアウト処理
    isLoggedIn = false
    // サインイン画面表示
    isShowSignInView = true
  }
}

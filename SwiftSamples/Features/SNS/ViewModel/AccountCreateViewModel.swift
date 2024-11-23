import Foundation
import _PhotosUI_SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

// TODO: 既存アカウントがある場合は名前とサムネイルしてこのユーザーですか？的な確認を取得したい
@MainActor
public class AccountCreateViewModel: ObservableObject {
  @Published var userName: String = ""
  @Published var profilePhotoItem: PhotosPickerItem? {
    didSet {
      setProfileUIImage()
    }
  }
  @Published var profileImage: UIImage?
  @Published var isImagePickerPresented = false
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false

  let onLoggedIn: () -> Void

  public init(onLoggedIn: @escaping () -> Void) {
    self.onLoggedIn = onLoggedIn
  }

  func onAppear() async {
    // ユーザー情報取得してみる
    
    // ユーザー情報があれば表示、おかえり
    
    // ユーザー情報がなければ設定画面表示
    
    // CreateAccountButtonの文言はだしわけ（「このアカウントで続ける」 or 「アカウントを作成する」）
  }
  
  // UIImageに変換
  func setProfileUIImage() {
    Task {
      profileImage = await profilePhotoItem?.toUIImage()
    }
  }

  // アカウント作成実行（すでにアカウントがある場合は上書きされる）
  func createAccount() async {
    isLoading = true
    guard let uploadImageURL = await uploadImageToStrorage() else {
      isLoading = false
      return
    }
    saveUserDataToFireStore(name: userName, profileImageURLString: uploadImageURL)
    self.isLoading = false
  }

  // プロフィール画像のアップロード（アップロード後のURLを返す）
  func uploadImageToStrorage() async -> String? {
    guard let profileImage else { return nil }
    
    // Storageのパスを設定
    let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
    
    // 画像をデータに変換
    guard let imageData = profileImage.jpegData(compressionQuality: 0.75) else {
      errorMessage = "Failed to convert image to data"
      return nil
    }

    do {
      // 画像データをアップロード
      // TODO: putDataAsyncの戻り値の詳細勉強したいかも
      _ = try await storageRef.putDataAsync(imageData)
      // アップロードした画像のURLを取得
      let imageURL = try await storageRef.downloadURL()
      return imageURL.absoluteString
    } catch {
      errorMessage = "Failed to upload image or fetch URL: \(error.localizedDescription)"
      return nil
    }
  }

  // FireStoreにアカウントデータを保存する
  func saveUserDataToFireStore(name: String, profileImageURLString: String) {
    guard let currentUser = Auth.auth().currentUser else {
      errorMessage = "Failed to get currentUser"
      return
    }
  
    // FireStoreのusersコレクション内にUIDでドキュメントを作る
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(currentUser.uid)

    userRef.setData([
      "name": name,
      "thumbnailURL": profileImageURLString
    ]) { error in
      if let error {
        self.errorMessage = "Error saving user data: \(error.localizedDescription)"
      } else {
        // アカウント登録完了したのでSNSHomeViewに戻る
        self.onLoggedIn()
      }
    }
    
  }
}

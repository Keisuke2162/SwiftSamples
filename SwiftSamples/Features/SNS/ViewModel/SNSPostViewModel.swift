import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import _PhotosUI_SwiftUI

@MainActor
public class SNSPostViewModel: ObservableObject {
  let user: SNSUser
  @Published var text: String = ""
  @Published var postPhotoItem: PhotosPickerItem? {
    didSet {
      setPostUIImage()
    }
  }
  @Published var postImage: UIImage?
  @Published var isImagePickerPresented = false
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
  @Published var isSuccessPost: Bool = false

  init(user: SNSUser) {
    self.user = user
  }

  // UIImageに変換
  func setPostUIImage() {
    Task {
      postImage = await postPhotoItem?.toUIImage()
    }
  }

  func sendPost() async {
    isLoading = true
    guard let uploadImageURL = await uploadImageToStrorage() else {
      isLoading = false
      return
    }
    saveUserDataToFireStore(imageURLString: uploadImageURL)
    self.isLoading = false
  }
  
  // 投稿画像をStorageにアップ（アップロード後のURLを返す）
  private func uploadImageToStrorage() async -> String? {
    guard let postImage else { return nil }
    
    let storageRef = Storage.storage().reference().child("post_images/\(UUID().uuidString).jpg")
    
    guard let imageData = postImage.jpegData(compressionQuality: 0.75) else {
      errorMessage = "Failed to convert image to data"
      return nil
    }

    do {
      _ = try await storageRef.putDataAsync(imageData)
      let imageURL = try await storageRef.downloadURL()
      return imageURL.absoluteString
    } catch {
      errorMessage = "Failed to upload image or fetch URL: \(error.localizedDescription)"
      return nil
    }
  }

  // 投稿データをFirestoreにアップ
  func saveUserDataToFireStore(imageURLString: String) {
    let data: [String: Any] = [
      "userID": user.userID ?? "unknown_user_id",
      "postText": text,
      "postImageURL": imageURLString,
      "createdAt": Date()
    ]
    // FireStoreのusersコレクション内にUIDでドキュメントを作る
    let db = Firestore.firestore()
    db.collection("posts").document(UUID().uuidString).setData(data) { error in
      if let error {
        self.errorMessage = "Failed post: \(error.localizedDescription)"
      } else {
        self.isSuccessPost = true
      }
    }
  }
}

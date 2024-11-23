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
      "userID": user.userID,
      "userName": user.userName,
      "userProfileImageURL": user.userProfileImageURL?.absoluteString ?? "",
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

public struct SNSPostView: View {
  @StateObject private var viewModel: SNSPostViewModel
  // @Environment(\.dismiss) var dismiss
  
  public init(viewModel: SNSPostViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      VStack {
        if let postImage = viewModel.postImage {
          ZStack {
            Image(uiImage: postImage)
              .resizable()
              .frame(maxWidth: .infinity)
              .aspectRatio(1, contentMode: .fill)
              .clipped()

            VStack {
              Spacer()
              HStack {
                Spacer()
                Button {
                  viewModel.isImagePickerPresented = true
                } label: {
                  Image(systemName: "camera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .foregroundStyle(Color.black)
                    .background(Color.gray)
                    .clipShape(Circle())
                }
              }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
          }
        } else {
          ZStack {
            Color.gray.opacity(0.4)
              .frame(maxWidth: .infinity)
              .aspectRatio(1, contentMode: .fill)
            // Button
            Button {
              viewModel.isImagePickerPresented = true
            } label: {
              Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(16)
                .foregroundStyle(Color.black)
                .background(Color.gray)
                .clipShape(Circle())
            }

          }
        }
        
        TextEditor(text: $viewModel.text)
          .padding(.horizontal, 16)

        Spacer()
        Button {
          Task {
            await viewModel.sendPost()
            // TODO: checkmark表示にアニメーションをつけてその分dismissをディレイしたい
            // dismiss()
          }
        } label: {
          Text("Post")
        }

      }
      .photosPicker(isPresented: $viewModel.isImagePickerPresented, selection: $viewModel.postPhotoItem)

      if viewModel.isLoading {
        SNSLoadingView()
          .ignoresSafeArea()
      }
      
      if viewModel.isSuccessPost {
        Color.blue.opacity(0.3)
          .background(ignoresSafeAreaEdges: .bottom)
        Text("Success Post!")
          .font(.title)
          .padding()
          .background(Color.blue)
          .foregroundStyle(Color.white)
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
  }
}

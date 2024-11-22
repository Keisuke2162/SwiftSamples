import SwiftUI
import PhotosUI

public struct AccountCreateView: View {
  @StateObject private var viewModel: AccountCreateViewModel

  public init(viewModel: AccountCreateViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    VStack {
      TextField("Input Username", text: $viewModel.userName)
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Button {
        viewModel.isImagePickerPresented = true
      } label: {
        Text("Select Profile Image")
          .padding()
          .background(Color.blue)
          .foregroundStyle(Color.white)
          .clipShape(.rect(cornerRadius: 8))
      }

      if let profileImage = viewModel.profileImage {
        Image(uiImage: profileImage)
          .resizable()
          .scaledToFit()
          .frame(width: 150, height: 150)
      } else {
        Color.indigo
          .frame(width: 150, height: 150)
      }

      Button {
        Task {
          await viewModel.createAccount()
        }
      } label: {
        Text("Create Account")
          .padding()
          .background(Color.green)
          .foregroundStyle(Color.white)
          .clipShape(.rect(cornerRadius: 8))
      }
      
      if !viewModel.errorMessage.isEmpty {
        Text(viewModel.errorMessage)
          .foregroundStyle(Color.red)
          .frame(height: 32)
      } else {
        Spacer().frame(height: 32)
      }
    }
    .padding()
    .photosPicker(isPresented: $viewModel.isImagePickerPresented, selection: $viewModel.profilePhotoItem)
  }
}



/*
 
 import SwiftUI
 import ImagePicker

 struct ImagePickerView: View {
     @Binding var isPresented: Bool
     @Binding var image: UIImage?

     var body: some View {
         ImagePicker(isPresented: $isPresented, image: $image, imageLimit: 1)
             .edgesIgnoringSafeArea(.all)
     }
 }
 PhotosPicker("写真を選択", selection: $selectedPhoto)
                 .onChange(of: selectedPhoto) { selectedPhoto in
                     Task { await loadImageFromSelectedPhoto(photo: selectedPhoto) }
                 }
         }
     }
     
     private func loadImageFromSelectedPhoto(photo: PhotosPickerItem?) async {
         if let data = try? await photo?.loadTransferable(type: Data.self) {
             self.uiImage = UIImage(data: data)
         }
     }
 PhotosPicker(selection: image, matching: .images, photoLibrary: .shared()) {
                 EmptyView()
             }
             .onChange(of: image.wrappedValue) { newImage in
                 // 画像が選択されたときの処理
                 if let newImage {
                     image.wrappedValue = newImage
                 }
             }
             .frame(width: 0, height: 0)

 */

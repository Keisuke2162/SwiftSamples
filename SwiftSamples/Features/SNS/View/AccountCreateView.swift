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
          .aspectRatio(contentMode: .fill)
          .frame(width: 160, height: 160)
          .clipShape(Circle())
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

import SwiftUI
import PhotosUI

public struct AccountCreateView: View {
  @StateObject private var viewModel: AccountCreateViewModel

  public init(viewModel: AccountCreateViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      VStack {
        Spacer()
        ZStack {
          if let profileImage = viewModel.profileImage {
            Image(uiImage: profileImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 160, height: 160)
              .clipShape(Circle())
          } else {
            Color.indigo
              .frame(width: 160, height: 160)
              .clipShape(Circle())
          }
          
          Button {
            viewModel.isImagePickerPresented = true
          } label: {
            Image(systemName: "camera.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 32, height: 32)
              .padding(16)
              .foregroundStyle(Color.black)
              .background(Color.gray)
              .clipShape(Circle())
          }
          .padding(.leading, 120)
          .padding(.top, 120)
        }
        
        TextField("Input Username", text: $viewModel.userName)
          .frame(height: 44)
          .padding(.horizontal, 32)
          .font(.title2.bold())
          .textFieldStyle(RoundedBorderTextFieldStyle())
        

        Spacer()
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
      
      if viewModel.isLoading {
        SNSLoadingView()
      }
    }
  }
}

//#Preview {
//  AccountCreateView(viewModel: AccountCreateViewModel(onLoggedIn: {}))
//}

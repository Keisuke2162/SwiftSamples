import SwiftUI

public struct SNSSigninView: View {
  @StateObject private var viewModel: SNSSigninViewModel
  
  public init(viewModel: SNSSigninViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack {
      VStack {
        // Emailログイン
        Text("Sign In")
          .font(.largeTitle)
          .padding()
        SecureField("Email", text: $viewModel.email)
          .padding()
          .padding(.horizontal, 32)
          .textFieldStyle(.roundedBorder)
        TextField("Password", text: $viewModel.password)
          .padding()
          .padding(.horizontal, 32)
          .textFieldStyle(.roundedBorder)
        Button("Sign In") {
          viewModel.signInWithEmail()
        }
        .padding()
        .padding(.horizontal, 32)
        .background(Color.blue)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Googleログイン
        Button("Sign In with Google") {
          viewModel.signInWithGoogle()
        }
        .frame(width: 200)
        .padding()
        .background(Color.red)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Appleログイン
        Button("Sign In with Apple") {
          viewModel.signInWithApple()
        }
        .frame(width: 200)
        .padding()
        .background(Color.indigo)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // 新規登録
        NavigationLink {
          SNSRegisterView(viewModel: SNSRegisterViewModel())
        } label: {
          Text("Create New Account")
            .foregroundStyle(Color.blue)
            .padding(.top, 24)
        }
      }
      .padding()
      if !viewModel.errorMessage.isEmpty {
        Text(viewModel.errorMessage)
          .foregroundStyle(Color.red)
          .frame(height: 32)
      } else {
        Spacer().frame(height: 32)
      }
      
    }
  }
}

//#Preview {
//  SNSSigninView(viewModel: SNSSigninViewModel())
//}

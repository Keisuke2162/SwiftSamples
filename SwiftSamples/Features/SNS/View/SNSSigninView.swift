import SwiftUI
import _AuthenticationServices_SwiftUI

public struct SNSSigninView: View {
  @StateObject private var viewModel: SNSSigninViewModel
  
  public init(viewModel: SNSSigninViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack {
      VStack {
        Spacer()
        // Emailログイン
        Text("Sign In")
          .font(.largeTitle)
          .padding()
        TextField("Email", text: $viewModel.email)
          .padding(.horizontal, 24)
          .textFieldStyle(.roundedBorder)
        SecureField("Password", text: $viewModel.password)
          .padding(.horizontal, 24)
          .textFieldStyle(.roundedBorder)
        Button("Sign In") {
          viewModel.signInWithEmail()
        }
        .frame(height: 44)
        .padding(.horizontal, 32)
        .background(Color.blue)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Googleログイン
        Button {
          viewModel.signInWithGoogle()
        } label: {
          Image("google_sign_in")
        }
        .frame(width: 200)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 32)
  
        // Appleログイン
        SignInWithAppleButton(.signIn) { request in
          viewModel.signInWithApple()
        } onCompletion: { _ in }
          .frame(width: 200, height: 44)
          .clipShape(.rect(cornerRadius: 8))
          .padding(.top, 16)
        Spacer()
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
    .navigationDestination(isPresented: $viewModel.isLoggedIn) {
      AccountCreateView(viewModel: AccountCreateViewModel(onLoggedIn: {
        viewModel.onLoggedIn()
      }))
    }
  }
}

//#Preview {
//  SNSSigninView(viewModel: SNSSigninViewModel())
//}

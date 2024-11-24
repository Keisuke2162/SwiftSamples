import SwiftUI
import AuthenticationServices

public struct SNSRegisterView: View {
  @StateObject private var viewModel: SNSRegisterViewModel
  
  public init(viewModel: SNSRegisterViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack {
      VStack {
        // Emailログイン
        Text("Sign Up")
          .font(.largeTitle)
          .padding()
        TextField("Email", text: $viewModel.email)
          .padding(.horizontal, 24)
          .textFieldStyle(.roundedBorder)
        SecureField("Password", text: $viewModel.password)
          .padding(.horizontal, 24)
          .textFieldStyle(.roundedBorder)
        Button("Sign Up") {
          viewModel.signUpWithEmail()
        }
        .frame(height: 44)
        .padding(.horizontal, 32)
        .background(Color.blue)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Googleサインアップ
        Button {
          viewModel.signUpWithGoogle()
        } label: {
          Image("google_sign_up")
        }
        .frame(width: 200)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 32)
        
        // Appleサインアップ
        SignInWithAppleButton(.signUp) { request in
          viewModel.signUpWithApple()
        } onCompletion: { _ in }
          .frame(width: 200, height: 44)
          .clipShape(.rect(cornerRadius: 8))
          .padding(.top, 16)
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
    .navigationDestination(isPresented: $viewModel.isSignedUp) {
      AccountCreateView(viewModel: AccountCreateViewModel(onLoggedIn: {
        viewModel.onLoggedIn()
      }))
    }
  }
}

//#Preview {
//  SNSRegisterView(viewModel: SNSRegisterViewModel())
//}

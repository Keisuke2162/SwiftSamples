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
          .padding()
          .padding(.horizontal, 32)
          .textFieldStyle(.roundedBorder)
        SecureField("Password", text: $viewModel.password)
          .padding()
          .padding(.horizontal, 32)
          .textFieldStyle(.roundedBorder)
        Button("Sign Up") {
          viewModel.signUpWithEmail()
        }
        .padding()
        .padding(.horizontal, 32)
        .background(Color.blue)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Googleログイン
        Button("Sign Up with Google") {
          viewModel.signUpWithGoogle()
        }
        .frame(width: 200)
        .padding()
        .background(Color.red)
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 8)
        
        // Appleログイン
        SignInWithAppleButton(.signUp) { request in
          viewModel.signUpWithApple()
        } onCompletion: { _ in }
          .frame(width: 200, height: 64)
          .clipShape(.rect(cornerRadius: 8))
          .padding(.top, 8)
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
      Text("Success SignUp")
    }
  }
}

//#Preview {
//  SNSRegisterView(viewModel: SNSRegisterViewModel())
//}

import SwiftUI

@MainActor
public class SNSRegisterViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var errorMessage = ""
  @Published var isLoggedIn = false
  
  public init() {
  }
  
  func signUpWithEmail() {
  }
  
  func signUpWithGoogle() {
  }
  
  func signUpWithApple() {
  }
}

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
        SecureField("Email", text: $viewModel.email)
          .padding()
          .padding(.horizontal, 32)
          .textFieldStyle(.roundedBorder)
        TextField("Password", text: $viewModel.password)
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
        Button("Sign Up with Apple") {
          viewModel.signUpWithApple()
        }
        .frame(width: 200)
        .padding()
        .background(Color.indigo)
        .foregroundStyle(Color.white)
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
  }
}

#Preview {
  SNSRegisterView(viewModel: SNSRegisterViewModel())
}


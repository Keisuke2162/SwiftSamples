import SwiftUI

@MainActor
public class SNSSigninViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var errorMessage = ""
  @Published var isLoggedIn = false

  public init() {
  }

  func signInWithEmail() {
  }

  func signInWithGoogle() {
  }

  func signInWithApple() {
  }
}

public struct SNSSigninView: View {
  @StateObject private var viewModel: SNSSigninViewModel

  public init(viewModel: SNSSigninViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    Text("a")
  }
}

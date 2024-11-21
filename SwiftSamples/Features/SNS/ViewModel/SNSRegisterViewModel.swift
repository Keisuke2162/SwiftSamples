import Foundation
import FirebaseCore
import CryptoKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

@MainActor
public class SNSRegisterViewModel: NSObject, ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var errorMessage = ""
  @Published var isSignedUp = false

  private var currentNonce: String?
  
  public override init() {
  }
  
  func signUpWithEmail() {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if let error {
        self.errorMessage = error.localizedDescription
      } else {
        self.isSignedUp = true
      }
    }
  }
  
  func signUpWithGoogle() {
    guard let rootViewController = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController }).first else {
      errorMessage = "RootViewController is not found"
      return
    }

    guard let clientID = FirebaseApp.app()?.options.clientID else {
      errorMessage = "Not found clientID"
      return
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
      if let error {
        self.errorMessage = error.localizedDescription
        return
      }
      
      guard let user = result?.user,
            let idToken = user.idToken?.tokenString else {
        self.errorMessage = "Google sign-in failed"
        return
      }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
      
      // ユーザー作成orサインイン
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error {
          self.errorMessage = "Firebase authentication failed: \(error.localizedDescription)"
        } else {
          self.isSignedUp = true
        }
      }
    }
  }
  
  func signUpWithApple() {
    let nonce = randomNonceString()
    currentNonce = nonce
    
    let appleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
    appleIDRequest.requestedScopes = [.fullName, .email]
    appleIDRequest.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

// TODO: SNSRegisterViewModelと全く同じ処理なのでまとめたい
extension SNSRegisterViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return ASPresentationAnchor()
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        errorMessage = "Invalid state: Nonce not set"
        return
      }
      
      guard let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        errorMessage = "Unable to fetch identity token"
        return
      }
      
      let credential = OAuthProvider.credential(
        providerID: AuthProviderID.apple,
        idToken: idTokenString,
        rawNonce: nonce
      )
      
      Auth.auth().signIn(with: credential) { [weak self] result, error in
        if let error {
          self?.errorMessage = error.localizedDescription
        } else {
          self?.isSignedUp = true
        }
      }
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    errorMessage = error.localizedDescription
  }

  // Nonceの生成、ハッシュ化
  private func randomNonceString(length: Int = 32) -> String {
    let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0..<16).map { _ in numericCast(arc4random_uniform(UInt32(charset.count))) }
      randoms.forEach { random in
        if remainingLength > 0 {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hasheData = SHA256.hash(data: inputData)
    return hasheData.compactMap { String(format: "%02x", $0) }.joined()
  }
}

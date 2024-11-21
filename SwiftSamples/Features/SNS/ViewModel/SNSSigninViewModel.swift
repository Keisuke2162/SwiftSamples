import Foundation

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


/*
 // メールアドレスでサインイン
 func signInWithEmail(email: String, password: String) {
     Auth.auth().signIn(withEmail: email, password: password) { result, error in
         if let error = error {
             self.errorMessage = error.localizedDescription
             self.isErrorShowing = true
         } else {
             print("Signed in with email")
         }
     }
 }
 
 // Googleでサインイン
    func signInWithGoogle() {
        GIDSignIn.sharedInstance().signIn(withPresenting: rootViewController) { user, error in
            if let error = error {
                print("Google sign-in failed: \(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                print("Google sign-in error: No ID token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                } else {
                    print("Logged in with Google!")
                }
            }
        }
    }

    // Appleでサインイン
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        guard let idToken = credential.identityToken,
              let idTokenString = String(data: idToken, encoding: .utf8) else { return }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Apple sign-in failed: \(error.localizedDescription)")
            } else {
                print("Logged in with Apple!")
            }
        }
    }
 */

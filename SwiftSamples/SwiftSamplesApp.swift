import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SwiftSamplesApp: App {
  @StateObject private var featureFlag = FeatureFlag()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      FeatureListView(store: .init(initialState: FeatureListReducer.State(), reducer: {
        FeatureListReducer()
      }))
      .environmentObject(featureFlag)
    }
  }
}

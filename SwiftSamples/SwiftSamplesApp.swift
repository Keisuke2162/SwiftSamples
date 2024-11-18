import SwiftUI

@main
struct SwiftSamplesApp: App {
  @StateObject private var featureFlag = FeatureFlag()
  var body: some Scene {
    WindowGroup {
      FeatureListView(store: .init(initialState: FeatureListReducer.State(), reducer: {
        FeatureListReducer()
      }))
      .environmentObject(featureFlag)
    }
  }
}

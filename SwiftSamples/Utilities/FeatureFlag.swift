import Foundation
import SwiftUI

class FeatureFlag: ObservableObject {
  @Published var isUseJsonFootballData: Bool {
    didSet {
      saveFlag(key: "isUseJsonFootballData", value: isUseJsonFootballData)
    }
  }

  init() {
    self.isUseJsonFootballData = UserDefaults.standard.bool(forKey: "isUseJsonFootballData")
  }

  private func saveFlag(key: String, value: Bool) {
    UserDefaults.standard.set(value, forKey: key)
  }
}

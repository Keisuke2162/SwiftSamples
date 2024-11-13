import SwiftUI

// iconを右側に配置するカスタムStyle
struct TrailingIconLabelStyle: LabelStyle {
  // Memo: Configuration → LabelStyleConfiguration
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

// カスタムStyleを.labelStyle(.trailingIcon)で呼び出せるようにする対応
// Self→LabelStyleのこと、Self()→TrailingIconLabelStyleのこと
extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}

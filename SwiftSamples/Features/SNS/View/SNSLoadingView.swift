import SwiftUI

public struct SNSLoadingView: View {
  @State var isAnimation = false

  public var body: some View {
    ZStack {
      Color.blue.opacity(0.3)
        .ignoresSafeArea()
      Image("pixel_bird")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)
        .rotationEffect(.degrees(isAnimation ? 360 : 0))
        .animation(.linear(duration: 0.5).repeatForever(autoreverses: false), value: isAnimation)
    }
    .onAppear {
      isAnimation = true
    }
    .onDisappear {
      isAnimation = false
    }
  }
}

import SwiftUI

struct HoloCard1: View {
  @State var rotation: CGFloat = 0

  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.blue)
      .frame(width: 300, height: 400)
      .shadow(radius: 8)
      .rotation3DEffect(
        .degrees(rotation),
        axis: (x:1, y:0, z:0)
      )
      .onAppear {
        withAnimation(.spring()) {
          rotation = 45
        }
      }
  }
}

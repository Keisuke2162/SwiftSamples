import SwiftUI

struct TinderCard: View {
  @State var cardList: [CardEntity] = [
    CardEntity(color: .blue),
    CardEntity(color: .yellow),
    CardEntity(color: .red),
    CardEntity(color: .gray),
    CardEntity(color: .brown),
  ]

  @State private var dragOffset: CGSize = .zero
  @State private var rotationAngle: Double = 0
  @State private var isSwipedAway: Bool = false

  var body: some View {
    let offsetY = 8 * (cardList.count - 1)

    ZStack {
      ForEach(Array(cardList.enumerated()), id: \.element.id) { index, card in
        CardView(color: card.color)
        // MEMO: 奥行き表現はなくても良さそう？
//          .offset(y: CGFloat(offsetY - (index * 8)))
//          .scaleEffect(1 - (CGFloat((cardList.count - 1) - index) * 0.01))
          .offset(
            x: index == cardList.count - 1 ? dragOffset.width : 0,
            y: index == cardList.count - 1 ? dragOffset.height: 0
          )
          .rotationEffect(.degrees(index == cardList.count - 1 ? rotationAngle: 0))
          .opacity(isSwipedAway && index == cardList.count - 1 ? 0 : 1)
          .gesture(
            index == cardList.count - 1 ? DragGesture()
              .onChanged { gesture in
                dragOffset = gesture.translation
                rotationAngle = Double(gesture.translation.width / 10)  // スワイプの量に対する回転角
              }
              .onEnded { gesture in
                let threshold: CGFloat = 100
                if abs(gesture.translation.width) > threshold {
                  withAnimation(.easeOut(duration: 0.3)) {
                    let direction: CGFloat = gesture.translation.width > 0 ? 1 : -1 // 左右の判定
                    // フレームアウト
                    dragOffset.width = direction * 500
                    dragOffset.height = 100
                    rotationAngle = direction * 30
                    isSwipedAway = true
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    removeTopCard()
                  }
                } else {
                  withAnimation {
                    dragOffset = .zero
                    rotationAngle = .zero
                  }
                }
              }
            : nil
          )
      }
    }
    .padding()
    .animation(.easeInOut, value: cardList)
  }

  private func removeTopCard() {
    if !cardList.isEmpty {
      cardList.removeLast()
      dragOffset = .zero
      rotationAngle = .zero
      isSwipedAway = false
    }
  }
}

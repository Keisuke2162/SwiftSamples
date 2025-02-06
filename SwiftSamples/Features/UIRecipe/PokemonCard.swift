import SwiftUI

struct CardEntity: Equatable {
  let id: UUID = UUID()
  let color: Color
}

struct PokemonCard: View {
  @State var imageNameList: [String] = ["hotaru", "kafuka", "keiryu", "nanoka", "ranha"]
  @State var cardList: [CardEntity] = [
    CardEntity(color: .blue),
    CardEntity(color: .yellow),
    CardEntity(color: .red),
    CardEntity(color: .gray),
    CardEntity(color: .brown),
  ]

  @State private var dragOffset: CGSize = .zero
  @State private var isDragging: Bool = false

  var body: some View {
    // let reservedCardList = Array(cardList.enumerated().reversed())
    let offsetY = 8 * (cardList.count - 1)

    ZStack {
      ForEach(Array(cardList.enumerated()), id: \.element.id) { index, card in
        CardView(color: card.color)
          .offset(y: CGFloat(offsetY - (index * 8)))
          .scaleEffect(1 - (CGFloat((cardList.count - 1) - index) * 0.01)) // 奥のViewを少し小さくする
          .offset(x: index == cardList.count - 1 ? dragOffset.width : 0)
          .gesture(
            index == cardList.count - 1 ? DragGesture()
              .onChanged { gesture in
                dragOffset = gesture.translation
              }
              .onEnded { gesture in
                let threshold: CGFloat = 100
                if abs(gesture.translation.width) > threshold {
                  withAnimation(.easeInOut(duration: 0.2)) {
                    dragOffset.width = gesture.translation.width > 0 ? 500 : -500
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    removeTopCard()
                  }
                } else {
                  withAnimation {
                    dragOffset = .zero
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
    }
  }
}

struct CardView: View {
  let color: Color

  var body: some View {
    Rectangle()
      .foregroundStyle(color)
      .frame(width: 300, height: 426)
  }
}

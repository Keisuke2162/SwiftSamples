//
//  PokemonCard.swift
//  SwiftSamples
//
//  Created by Kei on 2025/02/05.
//

import SwiftUI

struct CardEntity {
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

  var body: some View {
    ZStack {
      ForEach(cardList.indices, id: \.self) { index in
        CardView(color: cardList[index])
          .offset(y: -(CGFloat(cardList.count - 1 - index) * 16))
          .gesture(
            DragGesture()
              .onEnded({ value in
                let amount = value.translation.width
                if amount > 50 {
                  cardList.removeLast()

                } else if amount < -50 {
                  cardList.removeLast()
                }
              })
          )
      }
    }
    .animation(.easeInOut, value: cardList)
  }
}

struct CardView: View {
  let color: Color

  var body: some View {
    Rectangle()
      .foregroundStyle(color)
      .frame(width: 160, height: 320)
  }
}

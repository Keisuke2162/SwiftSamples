//
//  MoveCardList.swift
//  SwiftSamples
//
//  Created by Kei on 2025/02/28.
//

import SwiftUI

struct MoveCardList: View {
  // MEMO: [index: ScrollOffset]のデータ
  @State private var scrollOffsets: [Int: CGFloat] = [:]

  let cards: [String] = ["card-01", "card-02", "card-03", "card-04", "card-05", "card-06", "card-07", "card-08", "card-09", "card-10", "card-01", "card-02", "card-03", "card-04", "card-05", "card-06", "card-07", "card-08", "card-09", "card-10"].shuffled()
  var cardList: [String] {
    let list = cards + cards
    return list.shuffled()
  }

  @State private var angle: Double = 0
  
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 48) {
          ForEach(0..<cards.count, id: \.self) { index in
            MoveCardView(
              index: index,
              scrollOffset: scrollOffsets[index] ?? 0,
              imageName: cards[index]
            )
            .background(
              GeometryReader { geometry in
                Color.clear
                  .preference(key: ScrollViewOffsetPreferenceKey.self, value: [index: geometry.frame(in: .global).minY])
              }
            )
          }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
          scrollOffsets = value
        }
      }
    }
    
  }
}

struct MoveCardView: View {
  let index: Int
  let scrollOffset: CGFloat
  let imageName: String
  let backImageName: String = "card-00"
  var xAxis: CGFloat {
    switch index % 4 {
    case 0:
      -1
    case 1:
      -2
    case 2:
      1
    case 3:
      2
    default:
      0
    }
  }

  var body: some View {
    let screenHeight = UIScreen.main.bounds.height / 2
    let centerY = screenHeight
    let distanceFromCenter = scrollOffset - centerY
    // 角度を-180~180の間に
//    let rotationAngle = min(max(distanceFromCenter / screenHeight * 180, -180), 180)
    let rotation = distanceFromCenter / screenHeight * 180
    let rotationAngle = index % 2 == 0 ? rotation : -rotation
    ZStack {
      if rotationAngle > -90 && rotationAngle < 90 {
        Image(imageName)
          .resizable()
          .scaledToFit()
          .frame(width: 240)
          .clipShape(.rect(cornerRadius: 8))
          .opacity(rotationAngle <= 90 && rotationAngle >= -90 ? 1 : 0)
      } else {
        Image("card-00")
          .resizable()
          .scaledToFit()
          .frame(width: 240)
          .clipShape(.rect(cornerRadius: 8))
          .rotation3DEffect(.degrees(180), axis: (x: xAxis, y: 0.3, z: 0), perspective: 0.5)
          .opacity(rotationAngle > 90 || rotationAngle < -90 ? 1 : 0)
      }
    }
    .rotation3DEffect(.degrees(index % 2 == 0 ? -rotationAngle : rotationAngle), axis: (x: xAxis, y: 0.3, z: 0), perspective: 0.5)
    .frame(maxWidth: .infinity)
  }
}

// ScrollViewのOffsetを保持するPreferenceKey
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: [Int: CGFloat] = [:]
  static func reduce(value: inout [Int : CGFloat], nextValue: () -> [Int : CGFloat]) {
    let newValue = nextValue()
    for (key, newOffset) in newValue {
      value[key] = newOffset
    }
  }
}

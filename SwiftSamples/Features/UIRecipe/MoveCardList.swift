//
//  MoveCardList.swift
//  SwiftSamples
//
//  Created by Kei on 2025/02/28.
//

import SwiftUI

struct MoveCardList: View {
  let cards: [String] = ["card-01", "card-02", "card-03", "card-04", "card-05", "card-06", "card-07", "card-08", "card-09", "card-10"]
  let cardBack: String = "card-00"

  @State private var angle: Double = 0
  
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      VStack {
        ScrollView {
          ZStack {
            if angle <= 90 || angle >= 270 {
              Image("card-01")
                .resizable()
                .scaledToFit()
                .frame(width: 240)
                .clipShape(.rect(cornerRadius: 8))
            } else {
              Image("card-00")
                .resizable()
                .scaledToFit()
                .frame(width: 240)
                .clipShape(.rect(cornerRadius: 8))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
            }
          }
          .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
          // .animation(.easeInOut, value: angle)
          .frame(maxWidth: .infinity)
        }
        
        Slider(value: $angle, in: 0...360)
          .padding()
      }
    }
    
  }
}

struct MoveCardView: View {
  let imageName: String
  let backImageName: String = ""
  @State private var angle: Double = 0

  var body: some View {
    ZStack {
      if angle <= 90 || angle >= 270 {
        Image("card-01")
          .resizable()
          .scaledToFit()
          .frame(width: 240)
          .clipShape(.rect(cornerRadius: 8))
      } else {
        Image("card-00")
          .resizable()
          .scaledToFit()
          .frame(width: 240)
          .clipShape(.rect(cornerRadius: 8))
          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
      }
    }
    .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
    // .animation(.easeInOut, value: angle)
    .frame(maxWidth: .infinity)
  }
}

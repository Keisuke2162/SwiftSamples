//
//  ImagePaging2.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/17.
//

import SwiftUI

struct ImagePaging2: View {
  @State private var currentIndex = 0
  let photoItems = PhotoItem.mock()

  var body: some View {
    ZStack {
      TabView(selection: $currentIndex) {
        ForEach(0..<photoItems.count, id: \.self) { index in
          let item = photoItems[index]
          if let image = item.image {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .clipShape(.buttonBorder)
              .frame(maxWidth: .infinity)
              .padding()
          }
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .background(Color.gray)

      // ページング表示インジケータ
      VStack {
        Spacer()
        HStack(alignment: .center, spacing: 4) {
          ForEach(0..<photoItems.count, id: \.self) { index in
            if currentIndex == index {
              Text("⚫︎")
                .font(.system(size: 16))
            } else {
              Text("⚪︎")
                .font(.system(size: 16))
            }
          }
        }
        .padding(.bottom, 120)
      }
    }.frame(height: 500)
  }
}

#Preview {
  ImagePaging2()
}

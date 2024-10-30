//
//  ImageList.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/15.
//

import SwiftUI

struct ImageList: View {
    var body: some View {
      List(PhotoItem.mock()) { item in
        if let image = item.image {
          HStack(alignment: .center, spacing: 16) {
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 96, height: 96)
              .clipped()
              .clipShape(.buttonBorder)
            Text(item.title)
              .font(.title3.bold())
            Spacer()
          }
        }
      }
      .navigationTitle("List")
    }
}

#Preview {
    ImageList()
}

//
//  ImageGrid.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/15.
//

import SwiftUI

struct ImageGrid: View {
    var body: some View {
      ScrollView(.vertical) {
        LazyVGrid(columns: .init(repeating: GridItem(spacing: 2), count: 3), spacing: 2) {
          ForEach(PhotoItem.mock()) { item in
            if let image = item.image {
                GeometryReader {
                  Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: $0.size.width, height: $0.size.height)
                    .clipped()
                }
                .frame(height: 100)
                .contentShape(.rect)
            }
          }
        }
      }
      .navigationTitle("Grid")
    }
}

#Preview {
    ImageGrid()
}

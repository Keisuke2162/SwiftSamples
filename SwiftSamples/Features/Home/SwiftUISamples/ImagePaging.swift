//
//  ImagePaging.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/15.
//

import SwiftUI

struct ImagePaging: View {  
    var body: some View {
      VStack {
        TabView {
          ForEach(PhotoItem.mock()) { item in
            if let image = item.image {
              Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(.buttonBorder)
                .padding()
            }
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.brown)
      }
      .navigationTitle("Paging")
    }
}

#Preview {
    ImagePaging()
}

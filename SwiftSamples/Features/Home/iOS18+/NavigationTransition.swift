//
//  NavigationTransition.swift
//  SwiftSamples
//
//  Created by Kei on 2024/06/12.
//

import Foundation
import SwiftUI

struct NavigationTransitionContentView: View {
    @Namespace private var namespace
    var body: some View {
      ZStack {
        Color.gray.ignoresSafeArea()
        VStack() {
          Spacer()
          Image("pixel_bird")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 240)
          NavigationLink {
            if #available(iOS 18.0, *) {
              NavigationTransitionDetailView()
                .navigationTransition(.zoom(sourceID: "hoge", in: namespace))
            } else {
              NavigationTransitionDetailView()
            }
          } label: {
            if #available(iOS 18.0, *) {
              Text("Navigation")
                .matchedTransitionSource(id: "hoge", in: namespace)
            } else {
              Text("Navigation")
            }
          }
          .foregroundStyle(.white)
          Spacer()
        }
      }
    }
}

struct NavigationTransitionDetailView: View {
  var body: some View {
    ZStack {
      Color.cyan.ignoresSafeArea()
      VStack {
        Image("pixel_bird")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 240)
        Spacer()
      }
    }
  }
}

#Preview {
  NavigationTransitionContentView()
}

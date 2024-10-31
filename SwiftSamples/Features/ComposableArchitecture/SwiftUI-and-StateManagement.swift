//
//  SwiftUI-and-StateManagement.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/18.
//

/// https://www.pointfree.co/collections/composable-architecture/swiftui-and-state-management

import Foundation
import SwiftUI

struct PrimeContentView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination: EmptyView()) {
          Text("Counter demo")
        }
        NavigationLink(destination: EmptyView()) {
          Text("Favorite primes")
        }
      }
    }
    .navigationTitle("State management")
  }
}

#Preview {
  PrimeContentView()
}

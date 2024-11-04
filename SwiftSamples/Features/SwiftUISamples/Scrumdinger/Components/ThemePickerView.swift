//
//  ThemePickerView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/03.
//

import SwiftUI

struct ThemePickerView: View {
  @Binding var selection: Theme
  
  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ThemeView(theme: theme)
          .tag(theme)
      }
    }
    .pickerStyle(.navigationLink)
  }
}


#Preview {
  ThemePickerView(selection: .constant(.periwinkle))
}


//
//  SettingList.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/18.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct SttingListView: View {
  public var body: some View {
    VStack {
      Form {
        Section("Account") {
          Button(action: {
            
          }, label: {
            Text("Profile")
          })
        }
        Section("Support") {
          Button(action: {
            
          }, label: {
            Text("Contact")
          })
        }
        Section("Other") {
          Button(action: {
            
          }, label: {
            Text("Terms of Use")
          })
          Button(action: {
            
          }, label: {
            Text("Privacy Policy")
          })
        }
      }
    }
  }
}

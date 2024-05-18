//
//  ContactForm.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/18.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ContactForm {
  @ObservableState
  public struct State: Equatable {
    var name: String = ""
    var title: String = ""
    var mail: String = ""
    var content: String = ""
  }

  public enum Action: BindableAction {
    case sendButtonTapped
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .sendButtonTapped:
        return .none
      case .binding:
        return .none
      }
    }
  }
}

public struct ContactFormView: View {
  @Bindable var store: StoreOf<ContactForm>

  init(store: StoreOf<ContactForm>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Form {
        Section("Name") {
          TextField(text: $store.name) {
            Text("name")
          }
        }
        Section("Title") {
          TextField(text: $store.title) {
            Text("title")
          }
        }
        Section("Main Address") {
          TextField(text: $store.mail) {
            Text("main")
          }
        }
        Section("Content") {
          TextField(text: $store.content) {
            Text("content")
          }
          .frame(minHeight: 160)
        }
      }

      Button(action: {
      }, label: {
        Text("Send")
          .font(.title3.bold())
          .foregroundStyle(Color.white)
      })
      .frame(width: 160, height: 48)
      .background(Color.indigo)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .padding(16)
    }
    
  }
}

#Preview {
  ContactFormView(store: .init(initialState: ContactForm.State(), reducer: {
    ContactForm()
  }))
}

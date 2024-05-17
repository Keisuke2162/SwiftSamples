//
//  ReviewForm.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/18.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct ReviewForm {
  @ObservableState
  public struct State: Equatable {
    let productName: String = "Product"
    let maxStarCount: Int = 5
    var starCount: Int = 0
    var titleName: String = ""
    var review: String = ""
  }

  public enum Action: BindableAction {
    case starButtonTapped(Int)
    case sendButtonTapped
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .starButtonTapped(index):
        state.starCount = index + 1
        return .none
      case .sendButtonTapped:
        return .none
      case .binding(\.review):
        print("テスと \(state.review)")
        return .none
      case .binding:
        return .none
      }
    }
  }
}

struct ReviewFormView: View {
  @Bindable var store: StoreOf<ReviewForm>

  init(store: StoreOf<ReviewForm>) {
    self.store = store
  }

  var body: some View {
    VStack {
      Form {
        HStack {
          Text("Product")
            .font(.callout.bold())
          Spacer()
          Text(store.productName)
        }
        HStack {
          Text("Rating")
            .font(.callout.bold())
          Spacer()
          HStack {
            ForEach(0..<store.maxStarCount, id: \.self) { index in
              Button(action: {
                store.send(.starButtonTapped(index))
              }, label: {
                if store.starCount > index {
                  Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                } else {
                  Image(systemName: "star")
                    .foregroundStyle(Color.yellow)
                }
              })
              .buttonStyle(.plain)
            }
          }
        }
        TextField("Title", text: $store.titleName)
        TextEditor(text: $store.review)
          .foregroundStyle(Color.black)
          .frame(minHeight: 240)
          .overlay(alignment: .topLeading) {
            if store.review.isEmpty {
              Text("Input review text")
                .allowsHitTesting(false)
                .foregroundStyle(Color.black.opacity(0.2))
                .padding(.top, 8)
            }
          }
      }
      
      Button(action: {
        store.send(.sendButtonTapped)
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
    .background(Color.gray.opacity(0.1))
    .navigationTitle("Review")
  }
}

#Preview {
  ReviewFormView(store: .init(initialState: ReviewForm.State(), reducer: {
    ReviewForm()
  }))
}

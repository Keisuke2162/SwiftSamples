//
//  FeatureListView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct FeatureListReducer {
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
  }

  enum Action: BindableAction {
    case path(StackAction<Path.State, Path.Action>)
    case binding(BindingAction<State>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .path(_):
        return .none
      case .binding:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension FeatureListReducer {
  @Reducer(state: .equatable)
  enum Path {
      case imageRenderer(ImageRendererReducer)
      case asyncImageRenderer(AsyncImageRendererReducer)
      case liveActivity(LiveActivityReducer)
      case searchBooks(SearchBookList)
      case reviewForm(ReviewForm)
  }
}

struct FeatureListView: View {
  @Bindable var store: StoreOf<FeatureListReducer>

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Form {
        Section("iOS15+") {
        }
        Section("iOS16+") {
          NavigationLink(
            "ImageRenderer",
            state: FeatureListReducer.Path.State.imageRenderer(ImageRendererReducer.State())
          )
          NavigationLink(
            "ImageRenderer(AsyncImage)",
            state: FeatureListReducer.Path.State.asyncImageRenderer(AsyncImageRendererReducer.State())
          )
          NavigationLink(
            "LiveActivity",
            state: FeatureListReducer.Path.State.liveActivity(LiveActivityReducer.State())
          )
        }
        Section("Samples") {
          NavigationLink(
            "SearchBookApp",
            state: FeatureListReducer.Path.State.searchBooks(SearchBookList.State()))
        }
        Section("List Views") {
          NavigationLink { ImageList() } label: { Text("List") }
          NavigationLink { ImageGrid() } label: { Text("Grid") }
          NavigationLink { ImagePaging() } label: { Text("Paging") }
          NavigationLink(
            "Review Form",
            state: FeatureListReducer.Path.State.reviewForm(ReviewForm.State())
          )
        }
      }
      .navigationTitle("Feature")
    } destination: { store in
      switch store.case {
      case let .imageRenderer(store):
        ImageRendererView(store: store)
      case let .asyncImageRenderer(store):
        AsyncImageRendererView(store: store)
      case let .liveActivity(store):
        LiveActivityView(store: store)
      case let .searchBooks(store):
        SearchBookListView(store: store)
      case let .reviewForm(store):
        ReviewFormView(store: store)
      }
    }
  }
}

#Preview {
  FeatureListView(store: .init(initialState: FeatureListReducer.State(), reducer: {
    FeatureListReducer()
  }))
}

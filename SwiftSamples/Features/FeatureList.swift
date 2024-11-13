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
  
  
  // @State private var scrums = DailyScrum.sampleData
  // ScrumStoreのSourceOfTruth
  @StateObject private var scrumStore = ScrumStore()
  @State private var scrumErrorWrapper: ErrorWrapper?
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Form {
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
        Section("iOS18+") {
          NavigationLink {
            NavigationTransitionContentView()
          } label: {
            Text("navigationTransition")
          }
        }
        Section("TCA Samples") {
          NavigationLink(
            "書籍検索機能",
            state: FeatureListReducer.Path.State.searchBooks(SearchBookList.State()))
        }
        Section("SwiftUI Samples") {
          NavigationLink { ImageList() } label: { Text("List") }
          NavigationLink { ImageGrid() } label: { Text("Grid") }
          NavigationLink { ImagePaging() } label: { Text("Paging") }
          NavigationLink(
            "Review Form",
            state: FeatureListReducer.Path.State.reviewForm(ReviewForm.State())
          )
          NavigationLink { PickersView() } label: { Text("PickerView") }
          NavigationLink { FootballTopView() } label: { Text("Football API") }
          NavigationLink {
            SNSHomeView(viewModel: SNSHomeViewModel())
          } label: {
            Text("軽度なSNS")
          }
          NavigationLink {
            HologramCardView()
          } label: {
            Text("HologramCard")
          }
          NavigationLink { ScrumsView(scrums: $scrums) } label: { Text("Scrum") }
          NavigationLink { ScrumsView(scrums: $scrumStore.scrums) {
            // saveAction
            Task {
              do {
                // この書き方なscrumsを引数にとる意味なくね？
                try await scrumStore.save(scrums: scrumStore.scrums)
              } catch {
                scrumErrorWrapper = ErrorWrapper(error: error,
                                                 guidance: "Try again later.")
              }
            }
          } } label: { Text("Scrum") }
        }
      }
      .navigationTitle("Samples")
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
    .task {
      // ScrumStoreのLoadを実行
      do {
        try await scrumStore.load()
      } catch {
        // 取得エラー時はエラー画面表示
        scrumErrorWrapper = ErrorWrapper(error: error,
                                         guidance: "Scrumdinger will load sample data and continue.")
      }
    }
    .sheet(item: $scrumErrorWrapper, onDismiss: {
      // エラーになった時は仮でサンプルデータを表示する
      scrumStore.scrums = DailyScrum.sampleData
    }, content: { wrapper in
      ErrorView(errorWrapper: wrapper)
    })
  }
}

#Preview {
  FeatureListView(store: .init(initialState: FeatureListReducer.State(), reducer: {
    FeatureListReducer()
  }))
}

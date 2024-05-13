//
//  SearchBookList.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/12.
//

import CasePaths
import ComposableArchitecture
import Dependencies
import Foundation
import IdentifiedCollections
import SwiftUI

@Reducer
public struct SearchBookList {
  @ObservableState
  public struct State: Equatable {
    var bookRows: IdentifiedArrayOf<SearchBookListRow.State> = []
    var isLoading: Bool = false
    var query: String = ""
    
    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case queryChangeDebounce
    case searchBooksResponse(Result<[Book], Error>)
    case bookRows(IdentifiedActionOf<SearchBookListRow>)
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.googleBooksAPIClient) var googleBookAPIClient
  @Dependency(\.mainQueue) var mainQueue
  
  public init() {}
  
  private enum CancelID {
    case response
  }
  
  public var body: some ReducerOf<SearchBookList> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .queryChangeDebounce:
        guard !state.query.isEmpty else { return .none }
        state.isLoading = true

        return .run { [query = state.query] send in
          await send(
            .searchBooksResponse(
              Result {
                try await googleBookAPIClient.searchBooks(query: query)
              }
            )
          )
        }
      case let .searchBooksResponse(result):
        state.isLoading = false
        switch result {
        case let .success(books):
          state.bookRows = .init(uniqueElements: books.map { .init(book: $0) })
          return .none
        case .failure:
          return .none
        }
      case .bookRows:   // RowのDelegate
        return .none
      case .binding(\.query):
        return .run { send in
          await send(.queryChangeDebounce)
        }
        .debounce(
          id: CancelID.response,
          for: .seconds(0.3),
          scheduler: mainQueue
        )
      case .binding:
        return .none
      }
    }
    .forEach(\.bookRows, action: \.bookRows) {    //　複数の子Viewを作る
      SearchBookListRow()
    }
  }
}

public struct SearchBookListView: View {
  @Bindable var store: StoreOf<SearchBookList>

  public init(store: StoreOf<SearchBookList>) {
    self.store = store
  }

  public var body: some View {
    Group {
      if store.isLoading {
        ProgressView()
      } else {
        List {
          ForEach(store.scope(state: \.bookRows, action: \.bookRows), content: SearchBookListRowView.init(store:))
        }
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .navigationTitle("Seach Books")
    .searchable(text: $store.query, placement: .navigationBarDrawer, prompt: "Input Book")
  }
}

#Preview {
  SearchBookListView(
    store: .init(initialState: SearchBookList.State()) {
      SearchBookList()
    } withDependencies: { dependency in
      dependency.googleBooksAPIClient.searchBooks = { @Sendable _ in
        (1...20).map { .mock(id: "\($0)") }
      }
    }
  )
}

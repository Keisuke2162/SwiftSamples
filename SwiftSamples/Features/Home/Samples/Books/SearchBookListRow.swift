//
//  SearchBookListRow.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/13.
//

import CasePaths
import ComposableArchitecture
import Dependencies
import Foundation
import IdentifiedCollections
import SwiftUI

@Reducer
public struct SearchBookListRow {
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: String { book.id }
    let book: Book
  }

  public enum Action {
    case rowTapped
    case delegate
    
    @CasePathable
    public enum Delegate {
      case rowTapped
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .rowTapped:
        return .none
      case .delegate:
        return .none
      }
    }
  }
}

struct SearchBookListRowView: View {
  let store: StoreOf<SearchBookListRow>
  
  var body: some View {
    Button {
      store.send(.rowTapped)
    } label: {
      AsyncImage(url: store.book.thumbnailImageURL) { image in
        HStack(alignment: .center, spacing: 8) {
          image
            .resizable()
            .scaledToFit()
            .frame(width: 96, height: 96, alignment: .leading)
          Text(store.book.volumeInfo.title)
            .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      } placeholder: {
        ProgressView()
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  SearchBookListRowView(store: .init(initialState: SearchBookListRow.State(book: .mock(id: "1")), reducer: {
    SearchBookListRow()
  }))
}

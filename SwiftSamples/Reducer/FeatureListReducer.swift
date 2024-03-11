//
//  FeatureListReducer.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FeatureListReducer {
    @Reducer(state: .equatable)
    enum Path {
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }

    enum Action {
//        case goBackToScreen(id: StackElementID)
//        case goToABCButtonTapped
//        case popToRoot
        case path(StackAction<Path.State, Path.Action>)
    }


    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

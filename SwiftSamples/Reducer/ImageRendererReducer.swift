//
//  ImageRendererReducer.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ImageRendererReducer {
    @ObservableState
    struct State: Equatable {
        var imageCenter: CGPoint?
    }

    enum Action {
        case tapped(CGPoint)
        case tapSaveImageButton
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tapped(point):
                state.imageCenter = point
                return .none
            case .tapSaveImageButton:
                return .none
            }
        }
    }
}

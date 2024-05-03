//
//  NavigationSplitSampleReducer.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/31.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct NavigationSplitSampleReducer {
    @ObservableState
    struct State: Equatable {
        let titles: [NavigationSplitSampleView.TitleItem] = [.first, .second, .third]
        var selectedItem: NavigationSplitSampleView.TitleItem = .first
    }

    enum Action {
        case selectItem(NavigationSplitSampleView.TitleItem)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectItem(item):
                state.selectedItem = item
                return .none
            }
        }
    }
}

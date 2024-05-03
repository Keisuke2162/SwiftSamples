//
//  NavigationSplitSampleView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/31.
//

import ComposableArchitecture
import SwiftUI

struct NavigationSplitSampleView: View {
    @Bindable var store: StoreOf<NavigationSplitSampleReducer>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

    enum TitleItem: String, CaseIterable {
        case first = "First"
        case second = "Second"
        case third = "Third"
    }
}

#Preview {
    NavigationSplitSampleView(store: .init(initialState: NavigationSplitSampleReducer.State(), reducer: {
        NavigationSplitSampleReducer()
    }))
}

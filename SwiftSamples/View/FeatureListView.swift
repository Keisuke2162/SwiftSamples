//
//  FeatureListView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import SwiftUI

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
                }
            }
            .navigationTitle("Feature")
        } destination: { store in
            switch store.case {
            case let .imageRenderer(store):
                ImageRendererView(store: store)
            }
        }
    }
}

#Preview {
    FeatureListView(store: .init(initialState: FeatureListReducer.State(), reducer: {
        FeatureListReducer()
    }))
}

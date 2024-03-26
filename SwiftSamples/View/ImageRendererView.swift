//
//  ImageRendererView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

/// https://developer.apple.com/documentation/swiftui/imagerenderer

import ComposableArchitecture
import SwiftUI

struct ImageRendererView: View {
    @Bindable var store: StoreOf<ImageRendererReducer>

    var body: some View {
        let sushiView = sushiView()
        VStack {
            Spacer()
            sushiView
            Button(action: {
                let renderer = ImageRenderer(content: sushiView)
                if let size = store.state.backgroundSize {
                    renderer.proposedSize = ProposedViewSize(size)
                    store.send(.tapSaveImageButton(renderer.uiImage))
                }
            }, label: {
                Image(systemName: "camera")
            })
            .frame(width: 40, height: 40)
            Spacer()
        }
    }
    
    private func sushiView() -> some View {
        ZStack {
            GeometryReader(content: { geometry in
                Image("img-background-night")
                    .resizable()
                    .scaledToFit()
                    .gesture(
                        DragGesture(minimumDistance: 0).onChanged { gesture in
                            store.send(.tapped(gesture.location), animation: .easeOut)
                        }
                    )
                    .onAppear {
                        store.send(.getBackgroundSize(geometry.size))
                    }
                Image("img-sushi")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .position(
                        x: store.imageCenter?.x ?? geometry.size.width / 2,
                        y: store.imageCenter?.y ?? geometry.size.height / 2
                    )
                    .offset(y: store.imageCenter == nil ? 0 : -16)
            })
        }
        .frame(height: 300)
    }
}

#Preview {
    ImageRendererView(store: .init(initialState: ImageRendererReducer.State(), reducer: {
        ImageRendererReducer()
    }))
}

//
//  ImageRendererView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

/// https://developer.apple.com/documentation/swiftui/imagerenderer

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ImageRendererReducer {
    @ObservableState
    struct State: Equatable {
        var imageCenter: CGPoint?
        var backgroundSize: CGSize?
    }

    enum Action {
        case tapped(CGPoint)
        case tapSaveImageButton(UIImage?)
        case getBackgroundSize(CGSize)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tapped(point):
                state.imageCenter = point
                return .none
            case let .tapSaveImageButton(image):
                if let saveImage = image {
                    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil)
                }
                return .none
            case let .getBackgroundSize(size):
                state.backgroundSize = size
                return .none
            }
        }
    }
}

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

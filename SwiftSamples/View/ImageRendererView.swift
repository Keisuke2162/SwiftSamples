//
//  ImageRendererView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import SwiftUI

struct ImageRendererView: View {
    @Bindable var store: StoreOf<ImageRendererReducer>

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 300)
            sushiImage()
            Button(action: {
                
            }, label: {
                Image(systemName: "camera")
            })
            .frame(width: 40, height: 40)
        }
    }
    
    private func sushiImage() -> some View {
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
    }
}

#Preview {
    ImageRendererView(store: .init(initialState: ImageRendererReducer.State(), reducer: {
        ImageRendererReducer()
    }))
}

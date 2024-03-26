//
//  AsyncImageRendererView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/26.
//

import ComposableArchitecture
import SwiftUI

struct AsyncImageRendererView: View {
    @Bindable var store: StoreOf<AsyncImageRendererReducer>
    
    private func catView(image: Image) -> some View {
        ZStack {
            image.resizable().scaledToFit()
            Image("img-sushi")
                .resizable()
                .frame(width: 32, height: 32)
        }
    }

    var body: some View {
        VStack {
            Spacer()
            AsyncImage(url: store.state.imageURL) { image in
                VStack {
                    let catView = catView(image: image)
                    GeometryReader(content: { geometry in
                        catView
                            .onAppear {
                                store.send(.asyncImageSize(geometry.size))
                            }
                    })
                    Button(action: {
                        let renderer = ImageRenderer(content: catView)
                        if let size = store.state.imageSize {
                            renderer.proposedSize = ProposedViewSize(size)
                            store.send(.tapSaveImageButton(renderer.uiImage))
                        }
                    }, label: {
                        Text("Save Image")
                    })
                    .frame(height: 75)
                    .padding()
                }
            } placeholder: {
                Image("img-sushi")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            .padding()
            Spacer()
                Button(action: {
                    store.send(.fetchRandomCat)
                }, label: {
                    Text("Get Image")
                })
                .frame(height: 75)
                .padding()
            
        }
    }
}

#Preview {
    AsyncImageRendererView(store: .init(initialState: AsyncImageRendererReducer.State(), reducer: {
        AsyncImageRendererReducer()
    }))
}

//#Preview {
////    LiveActivityView(store: .init(initialState: LiveActivityReducer.State(), reducer: {
////        LiveActivityReducer()
////    }))
//}

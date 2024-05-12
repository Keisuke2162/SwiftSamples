//
//  AsyncImageRendererView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/26.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct AsyncImageRendererReducer {
    @ObservableState
    struct State: Equatable {
        var imageURL: URL?
        var imageSize: CGSize?
        var image: Image?
    }

    enum Action {
        case fetchRandomCat
        case randomCatResponse(Result<[CatItem], Error>)
        case asyncImageSize(CGSize)
        case tapSaveImageButton(UIImage?)
    }

    @Dependency(CatAPIClient.self) var catClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchRandomCat:
                return .run { send in
                    await send(.randomCatResponse(Result { try await catClient.getRandomCat() }))
                }
            case let .randomCatResponse(.success(item)):
                if let catItem = item.first {
                    state.imageURL = catItem.url
                }
                return .none
            case .randomCatResponse(.failure(_)):
                return .none
            case let .asyncImageSize(size):
                state.imageSize = size
                return .none
            case let .tapSaveImageButton(image):
                if let saveImage = image {
                    UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil)
                }
                return .none
            }
        }
    }
}

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

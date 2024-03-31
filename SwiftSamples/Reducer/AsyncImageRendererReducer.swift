//
//  AsyncImageRendererReducer.swift
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

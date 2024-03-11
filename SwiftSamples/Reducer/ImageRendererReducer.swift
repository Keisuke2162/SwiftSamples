//
//  ImageRendererReducer.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ImageRendererReducer {
    @ObservableState
    struct State: Equatable {
        var imageCenter: CGPoint?
    }

    enum Action {
        case tapped(CGPoint)
        case tapSaveImageButton(UIImage?)
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
            }
        }
    }
}

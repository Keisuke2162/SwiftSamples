//
//  LiveActivityReducer.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/13.
//

import ActivityKit
import ComposableArchitecture
import Foundation
import SwiftUI

extension Activity: Equatable {
    public static func == (lhs: Activity<Attributes>, rhs: Activity<Attributes>) -> Bool {
        lhs.id == rhs.id
    }
}

@Reducer
struct LiveActivityReducer {
    @ObservableState
    struct State: Equatable {
        var activity: Activity<DeliveyAttributes>?
        var isOrderd: Bool = false
    }

    enum Action {
        case tapStartLiveActivity(DeliveyAttributes)
        case tapUpdateLiveActivity
        case tapEndLiveActivity
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .tapStartLiveActivity(attributes):
                let contentState = DeliveyAttributes.ContentState(arrivalTime: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date(), 
                                                                  currentLocation: "Totsuka",
                                                                  order: "AAA")
                do {
                    state.activity = try Activity<DeliveyAttributes>.request(attributes: attributes, content: .init(state: contentState, staleDate: nil))
                    state.isOrderd = true
                } catch (let error) {
                    print(error.localizedDescription)
                }
                return .none
            case .tapUpdateLiveActivity:
                guard let activity = state.activity else { return .none }
                let updateState = DeliveyAttributes.ContentState(arrivalTime: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date(),
                                                                 currentLocation: "Kashiwa",
                                                                 order: "BBB")
                return .run { _ in
                    await activity.update(.init(state: updateState, staleDate: nil))
                }
            case .tapEndLiveActivity:
                guard let activity = state.activity else { return .none }
                let updateState = DeliveyAttributes.ContentState(arrivalTime: Date(),
                                                                 currentLocation: "???",
                                                                 order: "CCC")
                state.isOrderd = false
                return .run { _ in
                    await activity.end(.init(state: updateState, staleDate: nil), dismissalPolicy: .default)
                }
            }
        }
    }
}

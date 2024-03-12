//
//  LiveActivityView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/13.
//

import ComposableArchitecture
import SwiftUI

struct LiveActivityView: View {
    @Bindable var store: StoreOf<LiveActivityReducer>

    var body: some View {
        VStack {
            Button(action: {
                let attributes = DeliveryAttributes(deliverer: "Kei", deliveryDestination: "Kawasaki")
                store.send(.tapStartLiveActivity(attributes))
            }, label: {
                Text("Start Activity")
            })
            .padding(20)
            
            Button(action: {
                
            }, label: {
                Text("Update Activity")
            })
            .padding(20)
            
            Button(action: {
                
            }, label: {
                Text("End Activity")
            })
            .padding(20)
        }
    }
}

#Preview {
    LiveActivityView(store: .init(initialState: LiveActivityReducer.State(), reducer: {
        LiveActivityReducer()
    }))
}

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
            VStack(alignment: .trailing) {
                HStack {
                    Text("DynamicIslandExpandedRegion(.center)")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.centerSelectedItem)

                }
                .padding(4)
                HStack {
                    Text("DynamicIslandExpandedRegion(.bottom)")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.bottomSelectedItem)
                }
                .padding(4)
                HStack {
                    Text("compactLeading")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.leadingSelectedItem)
                }
                .padding(4)
            }
            Button(action: {
                store.send(.tapStartLiveActivity)
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

    struct ItemPickerView: View {
        @Binding var selectedItem: LiveActivityItem

        var body: some View {
            Picker("Item", selection: self.$selectedItem) {
                ForEach(LiveActivityItem.allCases) { item in
                    Text(item.rawValue)
                        .tag(item)
                }
            }
        }
    }
}

#Preview {
    LiveActivityView(store: .init(initialState: LiveActivityReducer.State(), reducer: {
        LiveActivityReducer()
    }))
}

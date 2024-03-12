//
//  DelivaryLiveActivity.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DelivaryLiveActivity: Widget {
    let kind: String = "SampleLiveActivityLiveActivity"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // LiveActivity
            DeliveryLiveActivityView(attribute: context.attributes, state: context.state)
        } dynamicIsland: { context in
            // DynamicIslandで表示するView
            DynamicIsland {
                // DynamicIslandをタップした際の拡大表示
                // .leading等で表示するエリアが決まっている
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.order)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.arrivalTime, style: .timer)
                        .frame(width: 50)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Current Location: \(context.state.currentLocation)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button("Change Order") {
                        return
                    }.buttonStyle(.automatic)
                }
            } compactLeading: {
                // DynamicIsland左部分の表示
                Text(context.state.order)
            } compactTrailing: {
                // DynamicIsland右部分の表示
                Text(context.state.arrivalTime, style: .timer)
                    .frame(width: 50)
                    .monospacedDigit()
            } minimal: {
                Text(context.state.order)
            }

        }
    }
}

struct DeliveryLiveActivityView: View {
    @State var attribute: DeliveryAttributes
    @State var state: DeliveryAttributes.ContentState

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Deliverer: \(attribute.deliverer)")
                Text("Location: \(state.currentLocation)")
                Text("Address: \(attribute.deliveryDestination)")
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Product")
                Text(state.order)
                    .font(.largeTitle)
            }
            Spacer()
        }
        .padding()
    }
}

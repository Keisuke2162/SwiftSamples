//
//  SampleLiveActivity.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/13.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SampleLiveActivity: Widget {
    let kind: String = "SampleLiveActivity"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleLiveActivityAttributes.self) { context in
            // ロック画面、バナーUI
            SampleLiveActivityView(attribute: context.attributes, state: context.state)
        } dynamicIsland: { context in
            // DynamicIslandで表示するView
            DynamicIsland {
                // DynamicIslandをタップした際の拡大表示
                // .leading等で表示するエリアが決まっている
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.dynamicIslandLeadingItem)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.dynamicIslandTrailingItem)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.dynamicIslandCenterItem)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.dynamicIslandBottomItem)
                }
            } compactLeading: {
                // DynamicIsland左部分の表示
                Text(context.state.compactLeadingItem)
            } compactTrailing: {
                // DynamicIsland右部分の表示
                Text(context.state.compactTrailingItem, style: .timer)
                    .frame(width: 50)
                    .monospacedDigit()
            } minimal: {
                // Minimal表示：アクティブなLiveActivityが2件以上存在する場合の表示
                Text(context.attributes.dynamicIslandMinimalItem)
            }

        }
    }
}

struct SampleLiveActivityView: View {
    @State var attribute: SampleLiveActivityAttributes
    @State var state: SampleLiveActivityAttributes.ContentState

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("A")
                Text("B")
                Text("C")
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Product")
            }
            Spacer()
        }
        .padding()
    }
}

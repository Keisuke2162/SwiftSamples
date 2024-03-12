//
//  SampleLiveActivityLiveActivity.swift
//  SampleLiveActivity
//
//  Created by Kei on 2024/03/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SampleLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SampleLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SampleLiveActivityAttributes {
    fileprivate static var preview: SampleLiveActivityAttributes {
        SampleLiveActivityAttributes(name: "World")
    }
}

extension SampleLiveActivityAttributes.ContentState {
    fileprivate static var smiley: SampleLiveActivityAttributes.ContentState {
        SampleLiveActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SampleLiveActivityAttributes.ContentState {
         SampleLiveActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SampleLiveActivityAttributes.preview) {
   SampleLiveActivityLiveActivity()
} contentStates: {
    SampleLiveActivityAttributes.ContentState.smiley
    SampleLiveActivityAttributes.ContentState.starEyes
}

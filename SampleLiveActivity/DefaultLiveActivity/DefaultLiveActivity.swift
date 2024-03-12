//
//  DefaultLiveActivity.swift
//  DefaultLiveActivity
//
//  Created by Kei on 2024/03/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DefaultLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DefaultLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DefaultLiveActivityAttributes.self) { context in
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

extension DefaultLiveActivityAttributes {
    fileprivate static var preview: DefaultLiveActivityAttributes {
        DefaultLiveActivityAttributes(name: "World")
    }
}

extension DefaultLiveActivityAttributes.ContentState {
    fileprivate static var smiley: DefaultLiveActivityAttributes.ContentState {
        DefaultLiveActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DefaultLiveActivityAttributes.ContentState {
         DefaultLiveActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DefaultLiveActivityAttributes.preview) {
   DefaultLiveActivity()
} contentStates: {
    DefaultLiveActivityAttributes.ContentState.smiley
    DefaultLiveActivityAttributes.ContentState.starEyes
}

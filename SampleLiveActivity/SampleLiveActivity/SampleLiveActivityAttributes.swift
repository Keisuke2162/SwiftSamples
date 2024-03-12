//
//  SampleLiveActivityAttributes.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/13.
//

import Foundation
import ActivityKit

struct SampleLiveActivityAttributes: ActivityAttributes, Equatable {
    // 動的なプロパティはContentStateで定義
    public struct ContentState: Codable, Hashable, Equatable {
        var dynamicIslandCenterItem: String
        var dynamicIslandBottomItem: String
        var compactLeadingItem: String
        var compactTrailingItem: Date
    }
    // 静的なプロパティ
    var id = UUID()
    var dynamicIslandLeadingItem: String
    var dynamicIslandTrailingItem: String
    var dynamicIslandMinimalItem: String
}

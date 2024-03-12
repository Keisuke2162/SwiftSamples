//
//  DeliveyAttributes.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/12.
//

import Foundation
import ActivityKit

struct DeliveryAttributes: ActivityAttributes, Equatable {
    // 動的なプロパティはContentStateで定義
    public struct ContentState: Codable, Hashable, Equatable {
        var arrivalTime: Date
        var currentLocation: String
        var order: String
    }
    // 静的なプロパティ
    var id = UUID()
    var deliverer: String
    var deliveryDestination: String
}

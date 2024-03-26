//
//  CatAPIClient.swift
//  SwiftSamples
//
//  Created by Kei on 2024/03/26.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct CatAPIClient {
    var getRandomCat: @Sendable () async throws -> [CatItem]
}

extension CatAPIClient: DependencyKey {
    static let liveValue: CatAPIClient = CatAPIClient(
        getRandomCat: {
            var components = URLComponents(string: "https://api.thecatapi.com/v1/images/search")!
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            let (data, _) = try await URLSession.shared.data(from: request.url!)
            do {
                let item = try JSONDecoder().decode([CatItem].self, from: data)
                return item
            } catch {
                throw APIError.unknown
            }
        }
    )
}

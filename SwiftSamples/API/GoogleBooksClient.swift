//
//  GoogleBooksClient.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/12.
//

import Foundation
import Dependencies
import DependenciesMacros
import XCTestDynamicOverlay

@DependencyClient
public struct GoogleBooksAPIClient {
  var searchBooks: @Sendable (_ query: String) async throws -> [Book]
}

extension GoogleBooksAPIClient: DependencyKey {
  public static let liveValue: Self = {
    return Self(
      searchBooks: { query in
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)")!
        var request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let books = try jsonDecoder.decode(BooksResult.self, from: data).items
        return books
      }
    )
  }()
}

private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  return decoder
}()

extension DependencyValues {
  public var googleBooksAPIClient: GoogleBooksAPIClient {
    get { self[GoogleBooksAPIClient.self] }
    set { self[GoogleBooksAPIClient.self] = newValue }
  }
}

extension GoogleBooksAPIClient: TestDependencyKey {
  public static let previewValue = Self(
    searchBooks: { _ in [] }
  )

  public static let testValue = Self()
}

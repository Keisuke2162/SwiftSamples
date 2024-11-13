//
//  ScrumStore.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/07.
//

import SwiftUI

// scrumsは@Publishedなのでメインスレッドで動作することが必要。＠MainActorにしておく

@MainActor
class ScrumStore: ObservableObject {
  @Published var scrums: [DailyScrum] = []
  
  private static func fileURL() throws -> URL {
    // Documentsディレクトリのscrums.dataという名前のファイルのURLを取得する
    try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("scrums.data")
  }
  
  func load() async throws {
    // Taskのジェネリックパラメータで[DailyScrum]かErrorを返すことを定義
    let task = Task<[DailyScrum], Error> {
      let fileURL = try Self.fileURL()
      guard let data = try? Data(contentsOf: fileURL) else {
        return []
      }
      let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
      return dailyScrums
    }
    // データの取得、デコード処理を待ってtask.valueをscrumsに代入
    // Error時はtask.valueにアクセスしたタイミングでエラーを返す
    let scrums = try await task.value
    self.scrums = scrums
  }
  

  func save(scrums: [DailyScrum]) async throws {
    let task = Task {
      let data = try JSONEncoder().encode(scrums)
      let outfile = try Self.fileURL()
      try data.write(to: outfile)
    }
    _ = try await task.value
  }
}

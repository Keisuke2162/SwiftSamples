//
//  ScrumsView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/03.
//

import SwiftUI

struct ScrumsView: View {
  @Binding var scrums: [DailyScrum]
  @State private var isPresentingNewScrumView = false
  // アプリのアクティブ状態を監視
  @Environment(\.scenePhase) private var scenePhase
  let saveAction: ()->Void
  
  var body: some View {
    List($scrums) { $scrum in
      NavigationLink {
        ScrumDetailView(scrum: $scrum)
      } label: {
        CardView(scrum: scrum)
      }
      .listRowBackground(scrum.theme.mainColor)
    }
    .navigationTitle("Daily Scrums")
    .toolbar {
      Button {
        isPresentingNewScrumView = true
      } label: {
        Image(systemName: "plus")
      }
      .accessibilityLabel("New Scrum")
    }
    .sheet(isPresented: $isPresentingNewScrumView) {
      NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
    }
    // MEMO: scenePhaseのonChangeが機能してない（inActiveにいつ移行してるか不明）なのでonDisappearで代用
    .onDisappear {
      saveAction()
    }
//    .onChange(of: scenePhase, initial: true, { oldValue, newValue in
//      print("テスト \(oldValue), \(newValue)")
//      if newValue == .inactive {
//        saveAction()
//      }
//    })
  }
}

#Preview {
  ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
}

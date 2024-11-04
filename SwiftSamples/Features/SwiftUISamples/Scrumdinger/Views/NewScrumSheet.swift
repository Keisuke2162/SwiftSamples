//
//  NewScrumSheet.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/05.
//

import SwiftUI

//ScrumDetailViewの.sheetとやってることはほぼ一緒。.sheetの中身を切り出しただけ

struct NewScrumSheet: View {
  @State private var newScrum = DailyScrum.emptyScrum
  // スクラムのデータ一覧のBinding
  @Binding var scrums: [DailyScrum]
  // 画面遷移用
  @Binding var isPresentingNewScrumView: Bool

  var body: some View {
    NavigationStack {
      ScrumDetailEditView(scrum: $newScrum)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss") {
              isPresentingNewScrumView = false
            }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Add") {
              scrums.append(newScrum)
              isPresentingNewScrumView = false
            }
          }
        }
    }
  }
}

#Preview {
  NewScrumSheet(scrums: .constant(DailyScrum.sampleData), isPresentingNewScrumView: .constant(true))
}

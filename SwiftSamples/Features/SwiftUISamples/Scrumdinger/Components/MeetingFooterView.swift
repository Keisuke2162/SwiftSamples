//
//  MeetingFooterView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/04.
//

import SwiftUI

struct MeetingFooterView: View {
  let speakers: [ScrumTimer.Speaker]
  var skipAction: ()->Void
  
  // 現在発言中のメンバーを取得(発言終了しているメンバいのindexの次)
  private var speakerNumber: Int? {
    guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil }
    return index + 1
  }
  private var isLastSpeaker: Bool {
    return speakers.dropLast().allSatisfy { $0.isCompleted }
  }
  private var speakerText: String {
    guard let speakerNumber = speakerNumber else { return "No more speakers" }
    return "Speaker \(speakerNumber) of \(speakers.count)"
  }
  
  var body: some View {
    VStack {
      HStack {
        if isLastSpeaker {
          // 最後の発言者の場合はスキップボタン非表示
          Text("Last Speaker")
        } else {
          Text(speakerText)
          Spacer()
          Button {
            skipAction()
          } label: {
            Image(systemName: "forward.fill")
          }
          .accessibilityLabel("Next speaker")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
}

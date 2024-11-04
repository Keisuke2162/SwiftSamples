//
//  MeetingView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/02.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
  @Binding var scrum: DailyScrum
  // スクラムタイマーclassのsource of truth
  @StateObject var scrumTimer = ScrumTimer()
  
  private var player: AVPlayer { AVPlayer.sharedDingPlayer }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16.0)
        .fill(scrum.theme.mainColor)
      VStack {
        MeetingHeaderView(
          secondsElapsed: scrumTimer.secondsElapsed,
          secondsRemaining: scrumTimer.secondsRemaining,
          theme: scrum.theme
        )
        Circle()
          .strokeBorder(lineWidth: 24)
        MeetingFooterView(speakers: scrumTimer.speakers) {
          // skipAction
          scrumTimer.skipSpeaker()
        }
      }
    }
    .padding()
    .foregroundColor(scrum.theme.accentColor)
    .onAppear {
      startScrum()
    }
    .onDisappear {
      endScrum()
    }
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private func startScrum() {
    // MeetingViewが表示されるたびに会議情報をセットしてスタート
    scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
    // 発言者が切り替わる時のアクションを定義しておく
    scrumTimer.speakerChangedAction = {
      // オーディオファイルの再生時間をリセットして再生
      player.seek(to: .zero)
      player.play()
    }
    scrumTimer.startScrum()
  }

  private func endScrum() {
    // 画面から離れる際にタイマーを停止（会議を終了）
    scrumTimer.stopScrum()
    // 実施したスクラムをHistoryに登録
    let newHistory = History(attendees: scrum.attendees)
    scrum.history.insert(newHistory, at: 0)
  }
}

#Preview {
  MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
}

/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation

/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.

@MainActor
final class ScrumTimer: ObservableObject {
  // 会議の出席者情報
  struct Speaker: Identifiable {
    let name: String
    // 発言の順番を終えた出席者はtrue
    var isCompleted: Bool
    let id = UUID()
  }
  
  // 発言者の名前
  @Published var activeSpeaker = ""
  // 会議開始からの経過時間
  @Published var secondsElapsed = 0
  // すべての出席者が発言する順番になるまでの秒数。
  @Published var secondsRemaining = 0
  // 会議の出席者（発言者順）
  private(set) var speakers: [Speaker] = []
  
  // ミーティングの長さ
  private(set) var lengthInMinutes: Int
  // 新しい人が話し始めるタイミングで実行されるクロージャ
  var speakerChangedAction: (() -> Void)?
  
  private weak var timer: Timer?
  private var timerStopped = false
  private var frequency: TimeInterval { 1.0 / 60.0 }
  private var lengthInSeconds: Int { lengthInMinutes * 60 }
  private var secondsPerSpeaker: Int {
    (lengthInMinutes * 60) / speakers.count
  }
  private var secondsElapsedForSpeaker: Int = 0
  private var speakerIndex: Int = 0
  private var speakerText: String {
    return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
  }
  // 発言開始時間（発言経過時間を計算するのに使う）
  private var startDate: Date?
  
  /**
   Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
   Use `startScrum()` to start the timer.
   
   - Parameters:
   - lengthInMinutes: The meeting length.
   -  attendees: A list of attendees for the meeting.
   */
  // 会議タイマーの初期化処理
  init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
    self.lengthInMinutes = lengthInMinutes
    self.speakers = attendees.speakers
    secondsRemaining = lengthInSeconds
    activeSpeaker = speakerText
  }
  
  // 会議タイマーのスタート処理
  func startScrum() {
    timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
      self?.update()
    }
    timer?.tolerance = 0.1
    changeToSpeaker(at: 0)
  }
  
  // 会議タイマーの停止処理
  func stopScrum() {
    timer?.invalidate()
    timerStopped = true
  }
  
  // タイマーを次のスピーカーに進める
  nonisolated func skipSpeaker() {
    Task { @MainActor in
      changeToSpeaker(at: speakerIndex + 1)
    }
  }
  
  private func changeToSpeaker(at index: Int) {
    if index > 0 {
      // 2人目以降のSpeakerの場合は1つ前のSpeakerを完了状態に変更
      let previousSpeakerIndex = index - 1
      speakers[previousSpeakerIndex].isCompleted = true
    }
    // 発言経過時間をリセット
    secondsElapsedForSpeaker = 0
    guard index < speakers.count else { return }
    speakerIndex = index
    activeSpeaker = speakerText
    
    secondsElapsed = index * secondsPerSpeaker
    secondsRemaining = lengthInSeconds - secondsElapsed
    startDate = Date()
  }
  
  nonisolated private func update() {
    
    Task { @MainActor in
      guard let startDate,
            !timerStopped else { return }
      let secondsElapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
      secondsElapsedForSpeaker = secondsElapsed
      self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
      guard secondsElapsed <= secondsPerSpeaker else {
        return
      }
      secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
      
      if secondsElapsedForSpeaker >= secondsPerSpeaker {
        changeToSpeaker(at: speakerIndex + 1)
        speakerChangedAction?()
      }
    }
  }
  
  /**
   Reset the timer with a new meeting length and new attendees.
   
   - Parameters:
   - lengthInMinutes: The meeting length.
   - attendees: The name of each attendee.
   */
  // 新しい会議情報でタイマーをリセットする
  func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
    self.lengthInMinutes = lengthInMinutes
    self.speakers = attendees.speakers
    secondsRemaining = lengthInSeconds
    activeSpeaker = speakerText
  }
}

// DailyScrumEntityのAttendeeをSpeakersに変換する処理
extension Array<DailyScrum.Attendee> {
  var speakers: [ScrumTimer.Speaker] {
    if isEmpty {
      return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
    } else {
      return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false) }
    }
  }
}

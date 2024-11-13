import SwiftUI

struct MeetingTimerView: View {
  // この画面でパラメータの編集はしないのでBindingじゃなくてOK
  // 親Viewが再描画されればこのコンポーネントも自然に再描画される
  let speakers: [ScrumTimer.Speaker]
  let theme: Theme

  private var currentSpeaker: String {
    speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
  }

  var body: some View {
    Circle()
      .strokeBorder(lineWidth: 24)
      .overlay {
        VStack {
          Text(currentSpeaker)
            .font(.title)
          Text("is speaking")
        }
        .accessibilityElement(children: .combine)
        .foregroundStyle(theme.accentColor)
      }
      .overlay {
        // Circleの上に人数分の円弧Shapeを表示する
        ForEach(speakers) { speaker in
          if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
            // すでに発言終了した分の円弧を埋める
            SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
              .rotation(Angle(degrees: -90))
              .stroke(theme.mainColor, lineWidth: 12)
          }
        }
        
      }
      .padding(.horizontal)
  }
}

#Preview {
  var speakers: [ScrumTimer.Speaker] = [
    .init(name: "Bill", isCompleted: true),
    .init(name: "Cathy", isCompleted: false)
  ]
  return MeetingTimerView(
    speakers: speakers,
    theme: .navy
  )
}

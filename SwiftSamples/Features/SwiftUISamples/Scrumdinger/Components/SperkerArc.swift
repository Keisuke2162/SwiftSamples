import SwiftUI

// 発言時の円弧を表示するShape（これを発言者の人数分作って表示する感じになる）
struct SpeakerArc: Shape {
  let speakerIndex: Int
  let totalSpeakers: Int

  // 360°のうち、speaker1人あたりの角度
  private var degreesPerSpeaker: Double {
    360.0 / Double(totalSpeakers)
  }

  // 今回のspeakerが開始するときの角度
  private var startAngle: Angle {
    Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)
  }

  // 今回のspeaker終了時の角度
  private var endAngle: Angle {
    Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
  }

  
  func path(in rect: CGRect) -> Path {
    // 円弧の直径
    let diameter = min(rect.size.width, rect.size.height) - 24.0
    // 半径
    let radius = diameter / 2.0
    let center = CGPoint(x: rect.midX, y: rect.midY)

    return Path { path in
      path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    }
  }
}

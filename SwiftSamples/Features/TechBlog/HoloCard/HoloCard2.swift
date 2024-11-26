import SwiftUI

struct HoloCard2: View {
  struct RotationAngle {
    var x: CGFloat
    var y: CGFloat
  }

  @State var rotation: RotationAngle = .init(x: .zero, y: .zero)
  @State var lastRotation: RotationAngle = .init(x: .zero, y: .zero)

  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(Color.blue)
      .frame(width: 300, height: 400)
      .shadow(radius: 8)
    // X軸の回転
      .rotation3DEffect(
        .degrees(rotation.x),
        axis: (x:1, y:0, z:0)
      )
    // Y軸の回転
      .rotation3DEffect(
        .degrees(rotation.y),
        axis: (x:0, y:1, z:0)
      )
    // ドラッグジェスチャー時のイベントを取得
      .gesture(
        DragGesture()
          .onChanged { value in
            // 感度の調整係数（小さいほど回転の大きさが小さくなる）
            let sensitivity: CGFloat = 0.5
            
            // X軸、Y軸に対してどれくらいの角度動かしたかを取得、感度の調整係数を掛けて実際にViewを回転させる角度を算出する。
            let deltaX = (value.location.x - value.startLocation.x) * sensitivity
            let deltaY = (value.location.y - value.startLocation.y) * sensitivity
            
            // 前回動かした角度に今回動かした分の角度を追加する
            rotation = RotationAngle(
              x: lastRotation.x + deltaY,  // 上下のドラッグでX軸回転
              y: lastRotation.y - deltaX  // 左右のドラッグでY軸回転
            )
          }
          .onEnded { _ in
            // ドラッグ終了時の角度を保存
            lastRotation = rotation
          }
      )
  }
}

import Foundation
import SwiftUI

public struct HologramCardView: View {
  struct RotationAngle {
    var x: CGFloat
    var y: CGFloat
  }
  
  // 画像のname一覧
  private let imageNameList: [String] = ["hotaru", "kafuka", "keiryu", "nanoka", "ranha", "reisa", "robin", "swan"]
  // 表示する画像のindex
  @State private var imagesIndex: Int = 0
  // 光沢エフェクト用の変数
  @State private var shimmerOffset: CGPoint = .zero
  // 現在の回転角度
  @State private var rotation: RotationAngle = .init(x: .zero, y: .zero)
  // ドラッグ終了時点の角度を保持（次の回転の基準になる）→ 指を離したら元の位置に戻るようにしたので使わなくなった
  @State private var lastRotation: RotationAngle = .init(x: .zero, y: .zero)
  // X方向の回転角度の上限値（上下ドラッグ）
  private let maxRotationX: CGFloat = 15
  // Y方向の回転角度の上限値（左右ドラッグ）
  private let maxRotationY: CGFloat = 50
  
  // カードの厚み係数
  private let cardThickness: CGFloat = 10
  
  // maxRotationを超えないように噛ませる関数
  private func limitRotation(_ maxRotationValue: CGFloat, _ value: CGFloat) -> CGFloat {
    return min(maxRotationValue, max(-maxRotationValue, value))
  }
  
  // 回転角度から光沢エフェクトを算出する
  private func updateShimmerPosition(xRotation: CGFloat, yRotation: CGFloat) -> CGPoint {
    // 回転の角度を -1 ~ 1 に正規化(-45°~45°のような値でくるがそれを均すイメージ)
    let normalizedX = limitRotation(maxRotationY, yRotation) / maxRotationY
    let normalizedY = limitRotation(maxRotationX, xRotation) / maxRotationX
    
    // イージング関数を適用
    let easedX = easeOutCubic(normalizedX)
    let easedY = easeOutCubic(normalizedY)
    
    // 0.2は光沢の移動範囲の調整係数
    return CGPoint(x: easedX * 0.8, y: easedY * 0.8)
  }
  
  // エッジの色を回転の角度に応じて計算
  private func edgeOpacity(_ maxRotation: CGFloat, _ rotation: CGFloat) -> Double {
    return abs(rotation) / maxRotation * 0.5
  }
  
  // イージング関数（より自然な動きを実現するため）→ 角度のつき加減によって光沢の移動を変化させることによって光沢がキラーンとなる
  private func easeOutCubic(_ x: CGFloat) -> CGFloat {
    // xは-1.0~1.0の範囲
    let normalized = (x + 1) / 2
    // イージング関数を適用
    let eased = 1 - pow(1 - normalized, 3)
    // 結果を-1~1の範囲に戻す
    return (eased * 2) - 1
  }
  
  public var body: some View {
    VStack {
      Spacer()
      ZStack {
        // カードの側面（右）
        GeometryReader { geometry in
          Rectangle()
            .fill(Color.gray)
            .frame(width: cardThickness)
            .offset(x: geometry.size.width / 2)
            .opacity(edgeOpacity(maxRotationY, rotation.y))
            .brightness(-0.3)
        }
        // カードの側面（下）
        GeometryReader { geometry in
          Rectangle()
            .fill(Color.gray)
            .frame(width: cardThickness)
            .offset(x: geometry.size.height / 2)
            .opacity(edgeOpacity(maxRotationX, rotation.x))
            .brightness(-0.3)
        }
        
        Image(imageNameList[imagesIndex])
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 300, height: 426)
          .clipShape(.rect(cornerRadius: 16))
        
        
        DynamicShimmerEffect(offset: shimmerOffset)
          .mask(
            RoundedRectangle(cornerRadius: 20)
          )
      }
      .frame(width: 300, height: 426)
      .shadow(radius: 10)
      // X軸の回転を制御（上下のドラッグ）
      .rotation3DEffect(
        .degrees(rotation.x),
        axis: (x: 1.0, y: 0.0, z: 0.0),
        perspective: 0.3  // 遠近感のパラメータ
      )
      // Y軸の回転を制御（左右のドラッグ）
      .rotation3DEffect(
        .degrees(rotation.y),
        axis: (x: 0.0, y: 1.0, z: 0.0),
        perspective: 0.3
      )
      // ドラッグジェスチェーの追加
      .gesture(
        DragGesture()
          .onChanged { value in
            // ジェスチャーの感度
            let sensitivity: CGFloat = 0.5
            
            // ドラッグした量から回転させる角度を算出
            let deltaX = (value.location.x - value.startLocation.x) * sensitivity
            let deltaY = (value.location.y - value.startLocation.y) * sensitivity
            
            // 回転の角度を更新（前回のドラッグ終了時点の角度からの差分更新）
            let newXValue = limitRotation(maxRotationX, lastRotation.x + deltaY)
            let newYValue = limitRotation(maxRotationY, lastRotation.y + deltaX)
            
            // 回転の角度を更新（指を離したら元の位置に戻すのでlastRotationは使わない）
            //          let newWidth = limitRotation(deltaY)
            //          let newHeight = limitRotation(deltaX)
            
            rotation = .init(x: newXValue, y: newYValue)
            // 回転の角度に応じて光沢の位置を更新する
            shimmerOffset = updateShimmerPosition(xRotation: newXValue, yRotation: newYValue)
          }
          .onEnded { _ in
            // ドラッグ終了時の角度を保存
            lastRotation = rotation
            
            // 左スワイプで前の画像
            if rotation.y < -49 {
              imagesIndex = imagesIndex == imageNameList.count - 1 ? 0 : imagesIndex + 1
              withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                rotation.y = .zero
                shimmerOffset.y = .zero
                lastRotation.y = .zero
              }
            }
            
            // 右スワイプで次の画像
            if rotation.y > 49 {
              imagesIndex = imagesIndex == 0 ? imageNameList.count - 1 : imagesIndex - 1
              withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                rotation.y = .zero
                shimmerOffset.y = .zero
                lastRotation.y = .zero
              }
            }
            
            // ドラッグ終了時に元の位置に戻す
            // response: アニメーションの時間, dampingFraction: バネの減衰率（小さいほど跳ねる）, blendDuration: アニメのブレンド時間
            //          withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
            //            rotation = .zero
            //            shimmerOffset = .zero
            //          }
          }
      )
      Spacer()
      Button {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
          rotation = .init(x: .zero, y: .zero)
          shimmerOffset = .zero
        }
      } label: {
        Text("Reset Rotation")
      }
    }
  }
}

public struct DynamicShimmerEffect: View {
  let offset: CGPoint
  
  public var body: some View {
    LinearGradient(
      gradient: Gradient(
        colors: [
          Color.white.opacity(0.0),
          Color.white.opacity(0.2),
          Color.white.opacity(0.4),
          Color.white.opacity(0.8),
          Color.white.opacity(0.4),
          Color.white.opacity(0.2),
          Color.white.opacity(0.0),
        ]
      ),
      startPoint: UnitPoint(x: 0.0 + offset.x, y: 0.0 + offset.y),
      endPoint: UnitPoint(x: 1.0 + offset.x, y: 1.0 + offset.y)
    )
    .padding(-16)
    .opacity(0.5)
    // 光沢のoffset移動に対してアニメーションをつける
    .animation(.easeOut(duration: 0.2), value: offset)
  }
}

#Preview {
  HologramCardView()
}

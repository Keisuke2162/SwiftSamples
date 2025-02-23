//
//  ThreeDimensionalCardView.swift
//  SwiftSamples
//
//  Created by Kei on 2025/02/23.
//

import SwiftUI

public struct ThreeDimensionalCardView<Content: View>: View {
  // 操作できる回転軸
  enum RotateDirection {
    case x
    case y
    case xy
  }
  struct RotationAngle {
    var x: CGFloat
    var y: CGFloat
  }

  let direction: RotateDirection
  let content: () -> Content

  // 現在の回転角度
  @State private var rotation: RotationAngle = .init(x: .zero, y: .zero)
  // ドラッグ終了時点の角度を保持（次の回転の基準になる）→ 指を離したら元の位置に戻るようにしたので使わなくなった
  @State private var lastRotation: RotationAngle = .init(x: .zero, y: .zero)
  // X方向の回転角度の上限値（上下ドラッグ）
  private let maxRotationX: CGFloat = 30
  // Y方向の回転角度の上限値（左右ドラッグ）
  private let maxRotationY: CGFloat = 30

  public var body: some View {
    content()
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
            let sensitivity: CGFloat = 0.2
            // ドラッグした量から回転させる角度を算出
            let deltaX = (value.location.x - value.startLocation.x) * sensitivity
            let deltaY = (value.location.y - value.startLocation.y) * sensitivity
            // 回転の角度を更新（前回のドラッグ終了時点の角度からの差分更新）
            let newXValue = limitRotation(maxRotationX, lastRotation.x + deltaY)
            let newYValue = limitRotation(maxRotationY, lastRotation.y + deltaX)

            rotation = switch direction {
            case .x:
                .init(x: -newXValue, y: .zero)
            case .y:
                .init(x: .zero, y: newYValue)
            case .xy:
                .init(x: -newXValue, y: newYValue)
            }
          }
          .onEnded { _ in
            // ドラッグ終了時に元の位置に戻す
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
              rotation = .init(x: .zero, y: .zero)
            }
          }
      )
  }

  // maxRotationを超えないように噛ませる関数
  private func limitRotation(_ maxRotationValue: CGFloat, _ value: CGFloat) -> CGFloat {
    return min(maxRotationValue, max(-maxRotationValue, value))
  }
}

public struct ThreeDimensionalCardSampleView: View {
  public var body: some View {
    ThreeDimensionalCardView(direction: .xy) {
      Image("pexels3")
        .resizable()
        .scaledToFit()
        .frame(width: 320)
        .clipShape(.rect(cornerRadius: 8))
    }
  }
}

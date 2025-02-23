//
//  ThreeDimensionalCardView.swift
//  SwiftSamples
//
//  Created by Kei on 2025/02/23.
//

import SwiftUI

public struct ThreeDimensionalCardView<Content: View>: View {
  // 操作できる回転軸
  enum RotationAxis {
    case x
    case y
    case xy
  }

  struct RotationAngle {
    var x: CGFloat
    var y: CGFloat
  }

  let rotationAxis: RotationAxis
  let content: () -> Content

  // 現在の回転角度
  @State private var rotation: RotationAngle = .init(x: .zero, y: .zero)
  // 回転角度を保持する場合に使うプロパティ
  @State private var lastRotation: RotationAngle = .init(x: .zero, y: .zero)
  // X軸回転の角度上限
  private let maxRotationX: CGFloat = 30
  // Y軸回転の角度上限
  private let maxRotationY: CGFloat = 30

  public var body: some View {
    content()
      // X軸（上下ドラッグ）
      .rotation3DEffect(
        .degrees(rotation.x),
        axis: (x: 1.0, y: 0.0, z: 0.0),
        perspective: 0.3  // 遠近感のパラメータ
      )
      // Y軸（左右ドラッグ）
      .rotation3DEffect(
        .degrees(rotation.y),
        axis: (x: 0.0, y: 1.0, z: 0.0),
        perspective: 0.3
      )
      .gesture(
        DragGesture()
          .onChanged { value in
            // ジェスチャーの感度
            let sensitivity: CGFloat = 0.2
            // ドラッグした量から回転角度を更新
            let deltaX = (value.location.x - value.startLocation.x) * sensitivity
            let deltaY = (value.location.y - value.startLocation.y) * sensitivity
            let newXValue = limitRotation(maxRotationX, deltaY)
            let newYValue = limitRotation(maxRotationY, deltaX)
            // 前回のドラッグ位置からの差分更新を行う場合
//            let newXValue = limitRotation(maxRotationX, lastRotation.x + deltaY)
//            let newYValue = limitRotation(maxRotationY, lastRotation.y + deltaX)

            rotation = switch rotationAxis {
            case .x:
                .init(x: -newXValue, y: .zero)
            case .y:
                .init(x: .zero, y: newYValue)
            case .xy:
                .init(x: -newXValue, y: newYValue)
            }
          }
          .onEnded { _ in
            // ドラッグ終了時も回転した状態を保持
//            lastRotation = rotation

            // ドラッグ終了時に元の位置に戻す
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
              rotation = .init(x: .zero, y: .zero)
            }
          }
      )
  }

  // maxRotationを超えない対応
  private func limitRotation(_ maxRotationValue: CGFloat, _ value: CGFloat) -> CGFloat {
    return min(maxRotationValue, max(-maxRotationValue, value))
  }
}

public struct ThreeDimensionalCardSampleView: View {
  public var body: some View {
    ThreeDimensionalCardView(rotationAxis: .y) {
      Image("pexels3")
        .resizable()
        .scaledToFit()
        .frame(width: 320)
        .clipShape(.rect(cornerRadius: 8))
    }
  }
}

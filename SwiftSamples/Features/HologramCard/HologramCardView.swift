import Foundation
import SwiftUI

public struct HologramCardView: View {
  // 光沢エフェクト用の変数
  @State private var shimmerOffset: CGPoint = .zero
  // 現在の回転角度
  @State private var rotation: CGSize = .zero
  // ドラッグ終了時点の角度を保持（次の回転の基準になる）
  @State private var lastRotation: CGSize = .zero
  // 回転角度の上限値
  private let maxRotation: CGFloat = 10
  
  // テスト出力用
  @State private var locationX: CGFloat = .zero
  @State private var locationY: CGFloat = .zero
  @State private var deltaX: CGFloat = .zero
  @State private var deltaY: CGFloat = .zero
  @State private var newWidth: CGFloat = .zero
  @State private var newHeight: CGFloat = .zero
  
  // maxRotationを超えないように噛ませる関数
  private func limitRotation(_ value: CGFloat) -> CGFloat {
    return min(maxRotation, max(-maxRotation, value))
  }
  
  // 回転角度から光沢エフェクトを算出する
  private func updateShimmerPosition(xRotation: CGFloat, yRotation: CGFloat) -> CGPoint {
    // 回転の角度 -45°~45° → 0~1 に変換する(45はmaxRitationの数値)
    let normalizedX = (limitRotation(yRotation) + maxRotation) / (maxRotation * 2)
    let normalizedY = (limitRotation(xRotation) + maxRotation) / (maxRotation * 2)
    // 0.2は光沢の移動範囲の調整係数
    return CGPoint(x: normalizedX * 0.3, y: normalizedY * 0.3)
  }
  
  public var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.blue.opacity(0.6))
      DynamicShimmerEffect(offset: shimmerOffset)
        .mask(
          RoundedRectangle(cornerRadius: 20)
        )
      VStack(alignment: .leading, spacing: 8) {
        Spacer()
        Text("location.x:    \(locationX)")
        Text("location.y:    \(locationY)")
        Text("deltaX:        \(deltaX)")
        Text("deltaY:        \(deltaY)")
        Text("newWidth:      \(newWidth)")
        Text("newHeight:     \(newHeight)")
      }
      .padding(.bottom, 16)
    }
    .frame(width: 300, height: 450)
    .shadow(radius: 10)
    // X軸の回転を制御（上下のドラッグ）
    .rotation3DEffect(
      .degrees(rotation.width),
      axis: (x: 1.0, y: 0.0, z: 0.0)
    )
    // Y軸の回転を制御（左右のドラッグ）
    .rotation3DEffect(
      .degrees(rotation.height),
      axis: (x: 0.0, y: 1.0, z: 0.0)
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
          let newWidth = limitRotation(lastRotation.width + deltaY)
          let newHeight = limitRotation(lastRotation.height + deltaX)
          rotation = CGSize(width: newWidth, height: newHeight)
          
          // 回転の角度に応じて光沢の位置を更新する
          shimmerOffset = updateShimmerPosition(xRotation: newWidth, yRotation: newHeight)
        }
        .onEnded { value in
          let sensitivity: CGFloat = 0.5
          
          locationX = value.location.x
          locationY = value.location.y
          deltaX = (value.location.x - value.startLocation.x) * sensitivity
          deltaY = (value.location.y - value.startLocation.y) * sensitivity
          newWidth = limitRotation(lastRotation.width + deltaY)
          newHeight = limitRotation(lastRotation.height + deltaX)
          // ドラッグ終了時の角度を保存
          lastRotation = rotation
        }
    )
  }
}

public struct DynamicShimmerEffect: View {
  let offset: CGPoint
  
  public var body: some View {
    LinearGradient(
      gradient: Gradient(
        colors: [
          Color.white.opacity(0.0),
          Color.white.opacity(0.4),
          Color.white.opacity(0.8),
          Color.white.opacity(0.4),
          Color.white.opacity(0.0),
        ]
      ),
      startPoint: UnitPoint(x: 0.0 + offset.x, y: 0.0 + offset.y),
      endPoint: UnitPoint(x: 1.0 + offset.x, y: 1.0 + offset.y)
    )
    .opacity(0.5)
    // 光沢のoffset移動に対してアニメーションをつける
    .animation(.easeOut(duration: 0.2), value: offset)
  }
}

#Preview {
  HologramCardView()
}

/*
 
 import SwiftUI
 
 struct HologramCard: View {
 // ジェスチャーの状態を管理
 @State private var rotation: CGSize = .zero
 @State private var lastRotation: CGSize = .zero
 
 // 光の強さを制御する変数
 @State private var shimmerOffset: CGFloat = 0
 
 var body: some View {
 GeometryReader { geometry in
 let dragGesture = DragGesture()
 .onChanged { value in
 // ドラッグの移動量から回転角度を計算
 let sensitivity: CGFloat = 0.5
 let deltaX = (value.location.x - value.startLocation.x) * sensitivity
 let deltaY = (value.location.y - value.startLocation.y) * sensitivity
 
 rotation = CGSize(
 width: lastRotation.width + deltaY,
 height: lastRotation.height - deltaX
 )
 
 // 光沢効果の位置を更新
 updateShimmerEffect(xRotation: rotation.width, yRotation: rotation.height)
 }
 .onEnded { _ in
 lastRotation = rotation
 }
 
 ZStack {
 // カードの基本レイヤー
 RoundedRectangle(cornerRadius: 20)
 .fill(
 LinearGradient(
 gradient: Gradient(colors: [
 Color(hue: 0.5, saturation: 0.3, brightness: 0.9),
 Color(hue: 0.6, saturation: 0.4, brightness: 0.8)
 ]),
 startPoint: .topLeading,
 endPoint: .bottomTrailing
 )
 )
 
 // ホログラム効果レイヤー
 ShimmerEffect(offset: shimmerOffset)
 .mask(
 RoundedRectangle(cornerRadius: 20)
 )
 }
 .frame(width: geometry.size.width, height: geometry.size.height)
 .shadow(radius: 10)
 // 3D回転エフェクトを適用
 .rotation3DEffect(
 .degrees(rotation.width),
 axis: (x: 1.0, y: 0.0, z: 0.0)
 )
 .rotation3DEffect(
 .degrees(rotation.height),
 axis: (x: 0.0, y: 1.0, z: 0.0)
 )
 .gesture(dragGesture)
 }
 }
 
 private func updateShimmerEffect(xRotation: CGFloat, yRotation: CGFloat) {
 // 回転角度から光沢効果の位置を計算
 let normalizedX = (xRotation + 180) / 360
 let normalizedY = (yRotation + 180) / 360
 shimmerOffset = (normalizedX + normalizedY) / 2
 }
 }
 
 
 
 
 
 // 光沢効果のビュー
 struct ShimmerEffect: View {
 let offset: CGFloat
 
 var body: some View {
 LinearGradient(
 gradient: Gradient(colors: [
 Color.white.opacity(0.0),
 Color.white.opacity(0.2),
 Color.white.opacity(0.4),
 Color.white.opacity(0.2),
 Color.white.opacity(0.0)
 ]),
 startPoint: UnitPoint(x: 0 + offset, y: 0 + offset),
 endPoint: UnitPoint(x: 1 + offset, y: 1 + offset)
 )
 .opacity(0.5)
 }
 }
 */

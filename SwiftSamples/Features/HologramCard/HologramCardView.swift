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
  private let maxRotation: CGFloat = 15
  
  // カードの厚み係数
  private let cardThickness: CGFloat = 10
  
  // テスト出力用
//  @State private var locationX: CGFloat = .zero
//  @State private var locationY: CGFloat = .zero
//  @State private var deltaX: CGFloat = .zero
//  @State private var deltaY: CGFloat = .zero
//  @State private var newWidth: CGFloat = .zero
//  @State private var newHeight: CGFloat = .zero
  
  // maxRotationを超えないように噛ませる関数
  private func limitRotation(_ value: CGFloat) -> CGFloat {
    return min(maxRotation, max(-maxRotation, value))
  }
  
  // 回転角度から光沢エフェクトを算出する
  private func updateShimmerPosition(xRotation: CGFloat, yRotation: CGFloat) -> CGPoint {
//    // 回転の角度 -45°~45° → 0~1 に変換する(45はmaxRitationの数値)
//    let normalizedX = (limitRotation(yRotation) + maxRotation) / (maxRotation * 2)
//    let normalizedY = (limitRotation(xRotation) + maxRotation) / (maxRotation * 2)
    
    // 回転の角度を -1 ~ 1 に正規化
    let normalizedX = limitRotation(yRotation) / maxRotation
    let normalizedY = limitRotation(xRotation) / maxRotation
    
    // イージング関数を適用
    let easedX = easeOutCubic(normalizedX)
    let easedY = easeOutCubic(normalizedY)
    
    // 0.2は光沢の移動範囲の調整係数
    return CGPoint(x: easedX * 0.8, y: easedY * 0.8)
  }
  
  // エッジの色を回転の角度に応じて計算
  private func edgeOpacity(_ rotation: CGFloat) -> Double {
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
    ZStack {
      // カードの側面（右）
      GeometryReader { geometry in
        Rectangle()
          .fill(Color.gray)
          .frame(width: cardThickness)
          .offset(x: geometry.size.width / 2)
          .opacity(edgeOpacity(rotation.height))
          .brightness(-0.3)
      }
      // カードの側面（下）
      GeometryReader { geometry in
        Rectangle()
          .fill(Color.gray)
          .frame(width: cardThickness)
          .offset(x: geometry.size.height / 2)
          .opacity(edgeOpacity(rotation.width))
          .brightness(-0.3)
      }
      
      Image("robin")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 300, height: 426)
        .clipShape(.rect(cornerRadius: 16))
      DynamicShimmerEffect(offset: shimmerOffset)
        .mask(
          RoundedRectangle(cornerRadius: 20)
        )
//      VStack(alignment: .leading, spacing: 8) {
//        Spacer()
//        Text("location.x:    \(locationX)")
//        Text("location.y:    \(locationY)")
//        Text("deltaX:        \(deltaX)")
//        Text("deltaY:        \(deltaY)")
//        Text("newWidth:      \(newWidth)")
//        Text("newHeight:     \(newHeight)")
//      }
//      .padding(.bottom, 16)
    }
    .frame(width: 300, height: 426)
    .shadow(radius: 10)
    // X軸の回転を制御（上下のドラッグ）
    .rotation3DEffect(
      .degrees(rotation.width),
      axis: (x: 1.0, y: 0.0, z: 0.0),
      perspective: 0.3  // 遠近感のパラメータ
    )
    // Y軸の回転を制御（左右のドラッグ）
    .rotation3DEffect(
      .degrees(rotation.height),
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
          let newWidth = limitRotation(lastRotation.width + deltaY)
          let newHeight = limitRotation(lastRotation.height + deltaX)
          rotation = CGSize(width: newWidth, height: newHeight)
          
          // 回転の角度に応じて光沢の位置を更新する
          shimmerOffset = updateShimmerPosition(xRotation: newWidth, yRotation: newHeight)
        }
        .onEnded { _ in
//          locationX = value.location.x
//          locationY = value.location.y
//          deltaX = (value.location.x - value.startLocation.x) * sensitivity
//          deltaY = (value.location.y - value.startLocation.y) * sensitivity
//          newWidth = limitRotation(lastRotation.width + deltaY)
//          newHeight = limitRotation(lastRotation.height + deltaX)
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
 // 必要に応じて、URLから画像を読み込むバージョン
 struct URLImageHologramCard: View {
     let imageURL: URL
     
     var body: some View {
         AsyncImage(url: imageURL) { phase in
             switch phase {
             case .success(let image):
                 ImageHologramCard(imageName: "") // AsyncImageの場合は別途実装が必要
             case .failure(_):
                 Text("Failed to load image")
             case .empty:
                 ProgressView()
             @unknown default:
                 EmptyView()
             }
         }
     }
 }
 */

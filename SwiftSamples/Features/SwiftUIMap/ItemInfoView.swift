import SwiftUI
import MapKit

struct ItemInfoView: View {
  @State private var lookAroundScene: MKLookAroundScene?
  @State private var selectedResult: MKMapItem
  @State private var route: MKRoute?

  public init(lookAroundScene: MKLookAroundScene? = nil, selectedResult: MKMapItem, route: MKRoute? = nil) {
    self.lookAroundScene = lookAroundScene
    self.selectedResult = selectedResult
    self.route = route
  }
  
  var body: some View {
    // LookAroundPreview: 特定の位置情報のLookAroundプレビューを表示する（Map関連のコンポーネント）
    LookAroundPreview(initialScene: nil)
      .overlay(alignment: .bottomTrailing) {
        HStack {
          Text("\(selectedResult.name ?? "")")
          if let traveTime {
            Text(traveTime)
          }
        }
        .font(.caption)
        .foregroundStyle(.white)
        .padding(8)
      }
      .onAppear {
        getLookAroundScene()
      }
      .onChange(of: selectedResult) { oldValue, newValue in
        getLookAroundScene()
      }
  }

  // MKLAookAroundSceneRequest: 指定されたMapItemのSceneを取得
  func getLookAroundScene() {
    lookAroundScene = nil
    Task {
      let request = MKLookAroundSceneRequest(mapItem: selectedResult)
      lookAroundScene = try? await request.scene
    }
  }
  
  // MapItemへの予想移動時間をStringに変換
  private var traveTime: String? {
    guard let route else { return nil }
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: route.expectedTravelTime)
  }
}

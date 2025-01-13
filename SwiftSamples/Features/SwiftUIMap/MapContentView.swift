import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
  static let tokyoTower = CLLocationCoordinate2D(
    latitude: 35.6586,
    longitude: 139.7454
  )
  static let tokyoSkyTree = CLLocationCoordinate2D(
    latitude: 35.7100152,
    longitude: 139.8107594
  )
}

extension MKCoordinateRegion {
  // 皇居周辺地域
  static let imperialPalace = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 35.6802117,
      longitude: 139.7576692
    ),
    span: MKCoordinateSpan(
      latitudeDelta: 0.5,
      longitudeDelta: 0.5
    )
  )
  // スカイツリー周辺地域
  static let skytree = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 35.7100152,
      longitude: 139.8107594
    ),
    span: MKCoordinateSpan(
      latitudeDelta: 0.1,
      longitudeDelta: 0.1
    )
  )
}

struct MapContentView: View {
  
  // Mapを表示するカメラの位置追跡
  @State private var position: MapCameraPosition = .automatic

  // 検索結果の表示
  @State private var searchResult: [MKMapItem] = []

  var body: some View {
    Map(position: $position) {
      // 1. Markerで指定の座標にマーカーを置ける
//       Marker("TokyoTower", coordinate: .tokyoTower)

      // 2. MarkerにはsystemImageを使える
//       Marker("TokyoTower", systemImage: "circle", coordinate: .tokyoTower)
      
      // 3. imageAssetも使える
//      Marker("TokyoTower", image: "", coordinate: .tokyoTower)
      
      // 4. monogramで3文字までのテキストも表示できる
//      Marker("TokyoTower", monogram: Text("AB"), coordinate: .tokyoTower)
//        .tint(.orange)

      // Annotationも同様に特定の座標にコンテンツを表示できる
      // Markerはバルーンアイコンの表示だがAnnotationはSwiftUIViewを表示できる
      // anchorは座標の上下左右どこにアイコンを表示するか
      Annotation("TokyoTower", coordinate: .tokyoTower, anchor: .bottom) {
        Image(systemName: "figure")
          .padding(4)
          .foregroundStyle(.indigo)
          .background(Color.blue)
          .clipShape(.rect(cornerRadius: 4))
      }
      // .hiddenでアイコンのみ表示
      .annotationTitles(.hidden)
      
      // BeantownButtonsの検索結果を表示するMarker
      ForEach(searchResult, id: \.self) { result in
        // MapItem型でMarkerを使うとMapItemのアイコン、色を使ってくれる
        Marker(item: result)
      }
    }
    // .realistic → 立体的なマップスタイル
     .mapStyle(.standard)
//     .mapStyle(.imagery(elevation: .realistic))
//    .mapStyle(.hybrid(elevation: .realistic))
    // safeAreaInsetを使うことでAppleMapsのロゴとかが隠れないようにしてる
    .safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        BeantownButtons(position: $position, searchResults: $searchResult)
          .padding(.top)
        Spacer()
      }
      .background(.thinMaterial)
    }
    .onChange(of: searchResult) { oldValue, newValue in
      // Annotationで表示しているTokyoTowerを画面内に入れながら検索結果を表示できる
      position = .automatic
    }
  }
}

#Preview {
  MapContentView()
}

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
  // カメラで表示しているMap範囲の追跡
  @State private var visibleRegion: MKCoordinateRegion?
  // 検索結果の表示
  @State private var searchResult: [MKMapItem] = []
  // 選択したMapItem（selectedTag: IntでMarkerに.tag(1)みたいにもできる。同じタイプのIDを持たないMarkerやAnnotationで使える）
  @State private var selectedResult: MKMapItem?
  // 選択したMapItemへの移動情報
  @State private var route: MKRoute?

  var body: some View {
    // 検索結果のうち、アイコンをタップしたら$selectedResultに入る
    // 選択できるのはMarkerのみ（AnnotationはMapItemを持ってないので選択できない）
    Map(position: $position, selection: $selectedResult) {
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
//      Annotation("TokyoTower", coordinate: .tokyoTower, anchor: .bottom) {
//        Image(systemName: "figure")
//          .padding(4)
//          .foregroundStyle(.indigo)
//          .background(Color.blue)
//          .clipShape(.rect(cornerRadius: 4))
//      }
//      // .hiddenでアイコンのみ表示
//      .annotationTitles(.hidden)
      
      // BeantownButtonsの検索結果を表示するMarker
      ForEach(searchResult, id: \.self) { result in
        // MapItem型でMarkerを使うとMapItemのアイコン、色を使ってくれる
        Marker(item: result)
      }
      .annotationTitles(.hidden)
    }
    // .realistic → 立体的なマップスタイル
     .mapStyle(.standard)
//     .mapStyle(.imagery(elevation: .realistic))
//    .mapStyle(.hybrid(elevation: .realistic))
    // safeAreaInsetを使うことでAppleMapsのロゴとかが隠れないようにしてる
    .safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        VStack(spacing: .zero) {
          BottomSheetView(selectedResult: selectedResult, route: route)

          BeantownButtons(position: $position, visibleRegion: visibleRegion, searchResults: $searchResult)
            .padding(.top)
        }
        Spacer()
      }
      .background(.thinMaterial)
    }
    .onChange(of: searchResult) { oldValue, newValue in
      // Annotationで表示しているTokyoTowerを画面内に入れながら検索結果を表示できる
      position = .automatic
    }
    // onMapCameraChange: ユーザがMapとのインタラクションを終了したタイミングで走る
    // インタラクト中に呼び出すにはfrequencyパラメータを渡す
    .onMapCameraChange { context in
      visibleRegion = context.region
    }
    // 選択したMarkerが更新されたタイミングで経路検索
    .onChange(of: selectedResult) { oldValue, newValue in
      getDirections()
    }
  }

  // ある地点（スカイツリー）から選択したMarkerへの移動経路
  func getDirections() {
    route = nil
    guard let selectedResult else { return }

    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: .tokyoSkyTree))
    request.destination = selectedResult

    Task {
      let direction = MKDirections(request: request)
      let response = try? await direction.calculate()
      route = response?.routes.first
    }
  }
}

#Preview {
  MapContentView()
}

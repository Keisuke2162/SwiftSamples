import SwiftUI
import MapKit

struct BeantownButtons: View {
  // マップ上に表示するカメラの位置
  @Binding var position: MapCameraPosition
  // マップ上に表示する検索結果
  @Binding var searchResults: [MKMapItem]

  var body: some View {
    HStack {
      Button {
        search(for: "playgrounds")
      } label: {
        Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
      }
      .buttonStyle(.borderedProminent)
      
      Button {
        search(for: "beaches")
      } label: {
        Label("Beaches", systemImage: "beach.umbrella")
      }
      .buttonStyle(.borderedProminent)
      
      Button {
        // カメラをスカイツリー周辺に移動（どのくらいの範囲を表示するかはMKCoordinateSpanで決定）
        position = .region(.skytree)
      } label: {
        Label("SkyTree", systemImage: "location.north.line.fill")
      }
      .buttonStyle(.bordered)

      Button {
        // カメラを皇居周辺に移動
        position = .region(.imperialPalace)
      } label: {
        Label("ImperialPalace", systemImage: "house.lodge.fill")
      }
      .buttonStyle(.bordered)

      
      /*
       Cameraについていろいろ
       */
      // MKMapItemで特定の場所を表示、カメラが勝手にズームインしてくれる
      Button {
        position = .item(MKMapItem(placemark: MKPlacemark(coordinate: .tokyoSkyTree)))
      } label: {
        Label("TokyoSkyTree1", systemImage: "1.lane")
      }
      .buttonStyle(.bordered)
      
      // pitch angleを使えば3Dで表現できる
      Button {
        position = .camera(
          MapCamera(
            centerCoordinate: .tokyoSkyTree,
            distance: 980,
            heading: 242,
            pitch: 60
          )
        )
      } label: {
        Label("TokyoSkyTree2", systemImage: "2.lane")
      }
      .buttonStyle(.bordered)
      
      // 現在位置の表示
      Button {
        // followsHeading: 端末の回転に合わせてマップを回転する？ fallback: 位置情報が取得できない場合に表示する位置
        // 現在位置を表示している場合はカメラ位置がuserLocationになる、ユーザーがマップを操作するとカメラ位置がユーザーを追跡しなくなる(positionByUser)仕様
        // アプリがカメラの位置を指定する場合はpositionedByUser状態ではない（ユーザーが操作していないので）
        position = .userLocation(followsHeading: false, fallback: .automatic)
      } label: {
        Label("CurrentLocation", systemImage: "location.circle.fill")
      }
      .buttonStyle(.bordered)
    }
    .labelStyle(.iconOnly)
  }

  func search(for query: String) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.resultTypes = .pointOfInterest
    request.region = MKCoordinateRegion(
      center: .tokyoTower,
      span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
    )

    Task {
      let search = MKLocalSearch(request: request)
      let response = try? await search.start()
      searchResults = response?.mapItems ?? []
    }
  }
}

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
        Label("SkyTree", systemImage: "house.lodge.fill")
      }
      .buttonStyle(.bordered)
      
//      Button {
//        search(for: "cafe")
//      } label: {
//        Label("Cafe", systemImage: "cup.and.saucer.fill")
//      }
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

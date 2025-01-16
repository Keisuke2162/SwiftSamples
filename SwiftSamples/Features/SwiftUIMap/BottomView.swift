import SwiftUI
import MapKit

public struct BottomSheetView: View {
  var selectedResult: MKMapItem?
  var route: MKRoute?

  public init(selectedResult: MKMapItem? = nil, route: MKRoute? = nil) {
    self.selectedResult = selectedResult
    self.route = route
  }

  public var body: some View {
    if let selectedResult {
      ItemInfoView(selectedResult: selectedResult, route: route)
        .frame(height: 128)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding([.top, .horizontal])
    } else {
      Text("TEST")
    }
  }
}

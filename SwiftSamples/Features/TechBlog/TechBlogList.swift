import SwiftUI

struct TechBlogList: View {
  var body: some View {
    VStack {
      Form {
        Section("HologramCard") {
          NavigationLink {
            HoloCard1()
          } label: {
            Text("HoloCard1")
          }
          NavigationLink {
            HoloCard2()
          } label: {
            Text("HoloCard2")
          }
        }
      }
    }
  }
}

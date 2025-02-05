import SwiftUI

struct ZStackMenu: View {
  @State var isShowMenu: Bool = false
  
  private var iconColor: Color {
    Color(hue: hue, saturation: saturation, brightness: brightness)
  }
  @State var hue: Double = 0.0
  @State var saturation: Double = 1.0
  @State var brightness: Double = 1.0
  
  var body: some View {
    ZStack {
      ZStack {
        Color.black
        VStack {
          Spacer()
          ColorPickerView(hue: $hue, saturation: $saturation, brightness: $brightness)
            .padding(.bottom, 32)
            .frame(height: 160)
        }
      }
      .ignoresSafeArea()

      
      ZStack {
        Color.white
          .clipShape(.rect(cornerRadius: 32))
        VStack {
          Rectangle()
            .frame(width: 80, height: 80)
            .foregroundStyle(iconColor)
            .clipShape(.rect(cornerRadius: 8))
//          Button {
//            isShowMenu.toggle()
//          } label: {
//            Text("Menu")
//          }
        }
        
      }
      .gesture(
        DragGesture()
          .onEnded({ value in
            let verticalAmount = value.translation.height
            if verticalAmount > 50 {
              // down swipe
              isShowMenu = false
            } else if verticalAmount < -50 {
              // up swipe
              isShowMenu = true
            }
          })
      )
      .offset(x: 0, y: isShowMenu ? -160 : 0)
      .ignoresSafeArea()
    }
    .animation(.easeInOut, value: isShowMenu)
  }
}


#Preview {
  ZStackMenu()
}

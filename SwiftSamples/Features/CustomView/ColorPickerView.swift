import SwiftUI

struct ColorSlider: View {
  @Binding var hue: Double
  @Binding var saturation: Double
  @Binding var brightness: Double
  let height: CGFloat

  init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>, height: CGFloat) {
    self._hue = hue
    self._saturation = saturation
    self._brightness = brightness
    self.height = height
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        LinearGradient(gradient: Gradient(colors: (0..<100).map { Color(hue: Double($0) / 100.0, saturation: 1, brightness: 1)}),
                       startPoint: .leading,
                       endPoint: .trailing)
          .overlay(
            RoundedRectangle(cornerRadius: height / 2)
              .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 4)
          )
        
        ZStack(alignment: .center) {
          Circle()
            .fill(.white)
            .frame(width: height, height: height)
          Circle()
            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
            .frame(width: height - 8, height: height - 8)
        }
        .offset(x: height / 2)
        .position(x: CGFloat(self.hue) * (geometry.size.width - height), y: geometry.size.height / 2)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              let newValue = gesture.location.x / geometry.size.width
              self.hue = min(max(Double(newValue), 0), 1)
            }
        )
      }
    }
  }
}

public struct SaturationSlider: View {
  @Binding var hue: Double
  @Binding var saturation: Double
  @Binding var brightness: Double
  let height: CGFloat

  init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>, height: CGFloat) {
    self._hue = hue
    self._saturation = saturation
    self._brightness = brightness
    self.height = height
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        LinearGradient(gradient: Gradient(colors: (0..<100).map { Color(hue: hue, saturation: (100 - Double($0)) / 100.0, brightness: 1)}),
                       startPoint: .leading,
                       endPoint: .trailing)
          .overlay(
            RoundedRectangle(cornerRadius: height / 2)
              .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 4)
          )
        
        ZStack(alignment: .center) {
          Circle()
            .fill(.white)
            .frame(width: height, height: height)
          Circle()
            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
            .frame(width: height - 8, height: height - 8)
        }
        .offset(x: height / 2)
        .position(x: CGFloat(1 - self.saturation) * (geometry.size.width - height), y: geometry.size.height / 2)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              let newValue = (geometry.size.width - gesture.location.x) / geometry.size.width
              self.saturation = min(max(Double(newValue), 0), 1)
            }
        )
      }
    }
  }
}

// 明度ピッカー
public struct BrightnessSlider: View {
  @Binding var hue: Double
  @Binding var saturation: Double
  @Binding var brightness: Double
  let height: CGFloat

  init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>, height: CGFloat) {
    self._hue = hue
    self._saturation = saturation
    self._brightness = brightness
    self.height = height
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        LinearGradient(gradient: Gradient(colors: (0..<100).map { Color(hue: hue, saturation: 1, brightness: (100 - Double($0)) / 100.0)}), startPoint: .leading, endPoint: .trailing)
          .overlay(
            RoundedRectangle(cornerRadius: height / 2)
              .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 4)
          )
        
        ZStack(alignment: .center) {
          Circle()
            .fill(.white)
            .frame(width: height, height: height)
          Circle()
            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
            .frame(width: height - 8, height: height - 8)
        }
        .offset(x: height / 2)
        .position(x: CGFloat(1 - self.brightness) * (geometry.size.width - height), y: geometry.size.height / 2)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              let newValue = (geometry.size.width - gesture.location.x) / geometry.size.width
              self.brightness = min(max(Double(newValue), 0), 1)
            }
        )
      }
    }
  }
}

public struct ColorPickerView: View {
  @Binding private var hue: Double
  @Binding private var saturation: Double
  @Binding private var brightness: Double
  private let sliderHeight: CGFloat = 32

  public init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>) {
    self._hue = hue
    self._saturation = saturation
    self._brightness = brightness
  }

  public var body: some View {
    VStack(spacing: 20) {
      // 色相スライダー
      ColorSlider(hue: $hue, saturation: $saturation, brightness: $brightness, height: sliderHeight)
        .frame(height: sliderHeight)
        .clipShape(.rect(cornerRadius: sliderHeight / 2))
        .accentColor(.gray)
      // 彩度スライダー
      SaturationSlider(hue: $hue, saturation: $saturation, brightness: $brightness, height: sliderHeight)
        .frame(height: sliderHeight)
        .clipShape(.rect(cornerRadius: sliderHeight / 2))
      // 明度スライダー
//      BrightnessSlider(hue: $hue, saturation: $saturation, brightness: $brightness, height: sliderHeight)
//        .frame(height: sliderHeight)
//        .clipShape(.rect(cornerRadius: sliderHeight / 2))
    }
    .padding()
  }
}

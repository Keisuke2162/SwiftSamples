import SwiftUI

enum Pickers: CaseIterable {
  case auto
  case wheel
  case inline
  case menu
  case segment
  case palette

  var pickerStyle: any PickerStyle {
    switch self {
    case .auto:
        .automatic
    case .wheel:
        .wheel
    case .inline:
        .inline
    case .menu:
        .menu
    case .segment:
        .segmented
    case .palette:
        .palette
    }
  }
}

struct PickersView: View {
  @State private var currentLeagueType: LeagueType = .japan
  
  
  
  var body: some View {
    ScrollView {
      // DefaultPickerStyle
      VStack {
        HStack {
          Text("DefaultPickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(.automatic)
        .padding()
      }
      
      // WheelPickerStyle
      VStack {
        HStack {
          Text("WheelPickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(WheelPickerStyle())
        .padding()
      }
      
      // InlinePickerStyle
      VStack {
        HStack {
          Text("InlinePickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(InlinePickerStyle())
        .padding()
      }
      
      // MenuPickerStyle
      VStack {
        HStack {
          Text("MenuPickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
      }
      
      // SegmentedPickerStyle
      VStack {
        HStack {
          Text("SegmentedPickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
      }
      
      // PalettePickerStyle
      VStack {
        HStack {
          Text("PalettePickerStyle").font(.headline).padding(.leading, 16)
          Spacer()
        }
        Picker("Select League", selection: $currentLeagueType) {
          ForEach(LeagueType.allCases) { league in
            Text(league.name).tag(league)
          }
        }
        .pickerStyle(PalettePickerStyle())
        .padding()
      }
      
      Spacer()
    }
  }
}

#Preview {
  PickersView()
}

// NavigationLinkPickerStyle
//      VStack {
//        HStack {
//          Text("NavigationLinkPickerStyle").font(.headline).padding(.leading, 16)
//          Spacer()
//        }
//        Picker("Select League", selection: $currentLeagueType) {
//          ForEach(LeagueType.allCases) { league in
//            Text(league.name).tag(league)
//          }
//        }
//        .pickerStyle(NavigationLinkPickerStyle())
//        .padding()
//      }

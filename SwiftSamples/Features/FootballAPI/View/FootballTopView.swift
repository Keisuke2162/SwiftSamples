import SwiftUI

struct FootballTopView: View {
  @State private var currentLeagueType: LeagueType = .japan

  var body: some View {
    Form {
      Picker("Select League", selection: $currentLeagueType) {
        ForEach(LeagueType.allCases) { league in
          Text(league.name).tag(league)
        }
      }
      .pickerStyle(PalettePickerStyle())
      .padding()
    }
  }
}

#Preview {
  FootballTopView()
}

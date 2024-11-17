import SwiftUI

struct FootballTopView: View {
  @EnvironmentObject var featureFlag: FeatureFlag
  @State private var currentLeagueType: LeagueType = .japan

  var body: some View {
    Form {
      Toggle(isOn: $featureFlag.isUseJsonFootballData) {
        Text("Use Local JSON Data")
      }
      Picker("\(currentLeagueType.iconText) Select League", selection: $currentLeagueType) {
        ForEach(LeagueType.allCases) { league in
          Text(league.name).tag(league)
        }
      }
      .pickerStyle(.menu)
      .padding()
      
      NavigationLink { StandingView(leagueType: currentLeagueType, isUseJSON: featureFlag.isUseJsonFootballData) } label: { Text("Standings") }
      NavigationLink { EmptyView() } label: { Text("Features") }
      NavigationLink { EmptyView() } label: { Text("PlayerStats") }
    }
  }
}

#Preview {
  FootballTopView()
}

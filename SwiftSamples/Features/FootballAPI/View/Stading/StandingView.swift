import SwiftUI

// TODO: ViewModelディレクトリに移動
@MainActor
class StandingViewModel: ObservableObject {
  @Published var standings: [Standing] = []
  @Published var isLoading = false
  let leagueType: LeagueType
  let isUseJSON: Bool
  
  init(leagueType: LeagueType, isUseJSON: Bool) {
    self.leagueType = leagueType
    self.isUseJSON = isUseJSON
  }
  
  func fetchStanding() async {
    isLoading = true
    do {
      let standingsResponse = try await FootballAPIClient.shared.fetchStandings(leagueType: leagueType, useLocalJson: isUseJSON)
      self.standings = standingsResponse
    } catch {
      // TODO: Error画面表示
    }
    isLoading = false
  }
}

public struct StandingView: View {
  @StateObject private var viewModel: StandingViewModel
  
  public init(leagueType: LeagueType, isUseJSON: Bool) {
    _viewModel = StateObject(wrappedValue: StandingViewModel(leagueType: leagueType, isUseJSON: isUseJSON))
  }
  
  public var body: some View {
    VStack(spacing: .zero) {
      HStack(spacing: 16) {
        Spacer()
        Text("Played")
          .foregroundStyle(Color.white)
          .font(.headline)
        Text("GD")
          .foregroundStyle(Color.white)
          .font(.headline)
        Text("Points")
          .foregroundStyle(Color.white)
          .font(.headline)
      }
      .padding(.vertical, 16)
      .padding(.trailing, 24)
      List {
        ForEach(viewModel.standings) { standing in
          StandingCell(standingItem: standing)
            .listRowBackground(Color.clear)
        }
        .listRowSeparator(.hidden)
        Spacer().frame(height: 120).listRowBackground(EmptyView())
          .listRowSeparator(.hidden)
      }
      .scrollContentBackground(.hidden)
      .listStyle(.plain)
    }
    .background(viewModel.leagueType.backgroundColor)
    .task {
      await viewModel.fetchStanding()
    }
  }
}

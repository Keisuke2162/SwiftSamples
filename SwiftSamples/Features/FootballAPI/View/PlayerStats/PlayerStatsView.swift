import SwiftUI

@MainActor
public class PlayerStatsViewModel: ObservableObject {
  @Published var topScorerStats: [PlayerStats] = []
  @Published var isLoading = false
  public let leagueType: LeagueType
  public let statType: StatType
  public let isUseJSON: Bool
  
  public init(leagueType: LeagueType, statType: StatType, isUseJSON: Bool) {
    self.leagueType = leagueType
    self.statType = statType
    self.isUseJSON = isUseJSON
  }

  func fetchScorer() async {
    isLoading = true
    do {
      switch statType {
      case .topScorers:
        self.topScorerStats = try await FootballAPIClient.shared.fetchTopScorers(leagueType: leagueType, useLocalJson: isUseJSON)
      case .topAssists:
        self.topScorerStats = try await FootballAPIClient.shared.fetchTopAssists(leagueType: leagueType, useLocalJson: isUseJSON)
      }
    } catch {
      // TODO: Error画面表示
    }
    isLoading = false
  }
}

public struct PlayerStatsView: View {
  @StateObject private var viewModel: PlayerStatsViewModel

  public init(viewModel: PlayerStatsViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    List {
      ForEach(Array(viewModel.topScorerStats.enumerated()), id: \.offset) { index, item in
        PlayerStatCell(viewModel: PlayerStatCellViewModel(statType: viewModel.statType, playerStatsItem: item, order: index))
          .listRowBackground(Color.clear)
      }
      .listRowSeparator(.hidden)
      Spacer().frame(height: 120).listRowBackground(EmptyView())
        .listRowSeparator(.hidden)
    }
    .padding(.top, 16)
    .scrollContentBackground(.hidden)
    .background(viewModel.leagueType.backgroundColor)
    .listStyle(.plain)
  }
}





/*
 public struct PlayerStatsView: View {
   @Bindable var store: StoreOf<PlayerStatsReducer>
   
   public var body: some View {
     NavigationStack {
       
     }
     .task {
       do {
         try await Task.sleep(for: .milliseconds(300))
         await store.send(.fetchTopScorer).finish()
       } catch {}
     }
   }
 }

 */

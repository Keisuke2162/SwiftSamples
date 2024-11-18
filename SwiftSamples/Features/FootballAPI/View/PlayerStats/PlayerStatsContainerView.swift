import SwiftUI

@MainActor
public class PlayerStatsContainerViewModel: ObservableObject {
  @Published var selectStatsType: StatType = .topScorers
  public let leagueType: LeagueType
  public let isUseJSON: Bool
  
  public init(leagueType: LeagueType, isUseJSON: Bool) {
    self.leagueType = leagueType
    self.isUseJSON = isUseJSON
  }

  func selectedType(type: StatType) {
    selectStatsType = type
  }
}

public struct PlayerStatsContainerView: View {
  @StateObject var viewModel: PlayerStatsContainerViewModel
  
  public init(viewModel: PlayerStatsContainerViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        ForEach(StatType.allCases, id: \.self) { type in
          Button(action: {
            viewModel.selectedType(type: type)
          }, label: {
            VStack {
              Text(type.title)
                .foregroundColor(viewModel.selectStatsType == type ? .white : .gray)
                .font(.headline)
              Rectangle()
                .fill(viewModel.selectStatsType == type ? .white : .gray)
                .frame(height: 4)
            }
          })
        }
      }
      .frame(height: 32)
      TabView(selection: $viewModel.selectStatsType) {
        PlayerStatsView(viewModel: PlayerStatsViewModel(leagueType: viewModel.leagueType, statType: .topScorers, isUseJSON: viewModel.isUseJSON))
          .tag(StatType.topScorers)
          .toolbarBackground(.hidden, for: .tabBar)
        PlayerStatsView(viewModel: PlayerStatsViewModel(leagueType: viewModel.leagueType, statType: .topAssists, isUseJSON: viewModel.isUseJSON))
          .tag(StatType.topAssists)
          .toolbarBackground(.hidden, for: .tabBar)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .animation(.easeInOut, value: viewModel.selectStatsType)
    }
    .background(viewModel.leagueType.backgroundColor)
  }
}

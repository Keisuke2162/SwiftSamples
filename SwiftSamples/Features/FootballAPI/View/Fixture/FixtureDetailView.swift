import SwiftUI

@MainActor
public class FixtureDetailViewModel: ObservableObject {
  @Published var homeDetail: FixtureDetail?
  @Published var awayDetail: FixtureDetail?
  @Published var isLoading = false
  let leagueType: LeagueType
  let fixture: Fixture
  let isUseJSON: Bool

  public init(leagueType: LeagueType, fixture: Fixture, isUseJSON: Bool) {
    self.leagueType = leagueType
    self.fixture = fixture
    self.isUseJSON = isUseJSON
  }

  func fetchFixtureDetail() async {
    isLoading = true
    do {
      let homeFixtureDetailResponse = try await FootballAPIClient.shared.fetchFixtureDetail(teamID: fixture.teams.home.id, fixtureID: fixture.id, isHome: true, useLocalJson: isUseJSON)
      let awayFixtureDetailResponse = try await FootballAPIClient.shared.fetchFixtureDetail(teamID: fixture.teams.away.id, fixtureID: fixture.id, isHome: false, useLocalJson: isUseJSON)
      self.homeDetail = homeFixtureDetailResponse
      self.awayDetail = awayFixtureDetailResponse
    } catch {
      // TODO: Error画面表示
    }
    isLoading = false
  }
}

public struct FixtureDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var viewModel: FixtureDetailViewModel

  public init(viewModel: FixtureDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 16) {
      // ヘッダー
      HStack {
        Button(action: {
          dismiss()
        }, label: {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.white)
        })
        Spacer()
      }
      .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 0))
      
      ScrollView {
        // スコア表示領域
        FixturesCell(fixture: viewModel.fixture)
          .padding(.horizontal, 24)
        Spacer().frame(height: 32)

        // TODO: 得点者
        // スタッツ表示領域(statsTypeのenumで表示分けれるようにしたい)
        if let homeDetail = viewModel.homeDetail, let awayDetail = viewModel.awayDetail {
          VStack(spacing: 48) {
            // 総シュート
            FixtureStatsView(
              viewModel: FixtureStatsViewModel(
                statsType: .totalShots,
                homeValue: homeDetail.totalShots,
                awayValue: awayDetail.totalShots,
                home: viewModel.fixture.teams.home,
                away: viewModel.fixture.teams.away)
            )
            // 枠内シュート
            FixtureStatsView(
              viewModel: FixtureStatsViewModel(
                statsType: .shotsOnGoal,
                homeValue: homeDetail.shotsOnGoal,
                awayValue: awayDetail.shotsOnGoal,
                home: viewModel.fixture.teams.home,
                away: viewModel.fixture.teams.away)
            )
            // ポゼッション
            FixtureStatsView(
              viewModel: FixtureStatsViewModel(
                statsType: .ballPossession,
                homeValue: homeDetail.ballPossession,
                awayValue: awayDetail.ballPossession,
                home: viewModel.fixture.teams.home,
                away: viewModel.fixture.teams.away)
            )
            // xG
            FixtureStatsView(
              viewModel: FixtureStatsViewModel(
                statsType: .expectedGoals,
                homeValue: homeDetail.expectedGoals,
                awayValue: awayDetail.expectedGoals,
                home: viewModel.fixture.teams.home,
                away: viewModel.fixture.teams.away)
            )
          }
        }
        // TODO: メンバー
        Spacer()
      }
    }
    .background(viewModel.leagueType.backgroundColor)
    .task {
      await viewModel.fetchFixtureDetail()
    }
    .navigationBarBackButtonHidden()
  }
}

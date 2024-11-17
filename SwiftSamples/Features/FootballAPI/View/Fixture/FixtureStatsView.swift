import SwiftUI

public class FixtureStatsViewModel {
  public let statsType: StatisticType
  public let homeValue: String
  public let awayValue: String
  public let home: FixtureTeam
  public let away: FixtureTeam
  
  public var homeIntValue: CGFloat {
    CGFloat(Int(homeValue.extractNumericPart()) ?? 0)
  }
  public var awayIntValue: CGFloat {
    CGFloat(Int(awayValue.extractNumericPart()) ?? 0)
  }
  public var totalIntValue: CGFloat {
    homeIntValue + awayIntValue
  }
  
  public init(statsType: StatisticType, homeValue: String, awayValue: String, home: FixtureTeam, away: FixtureTeam) {
    self.statsType = statsType
    self.homeValue = homeValue
    self.awayValue = awayValue
    self.home = home
    self.away = away
  }

  func getStatsBarWidth(screenWidth: CGFloat, isHome: Bool) -> CGFloat {
    if isHome {
      return totalIntValue > 0 ? screenWidth * (CGFloat(homeIntValue) / CGFloat(totalIntValue)) : 0
    } else {
      return totalIntValue > 0 ? screenWidth * (CGFloat(awayIntValue) / CGFloat(totalIntValue)) : 0
    }
  }
}

public struct FixtureStatsView: View {
  let viewModel: FixtureStatsViewModel
  
  public init(viewModel: FixtureStatsViewModel) {
    self.viewModel = viewModel
  }
  
  public var body: some View {
    VStack {
      HStack {
        Spacer()
        Text(viewModel.homeValue)
          .foregroundColor(Color.white)
          .font(.subheadline)
        Spacer()
        Text(viewModel.statsType.rawValue)
          .foregroundColor(Color.white)
          .font(.subheadline)
        Spacer()
        Text(viewModel.awayValue)
          .foregroundColor(Color.white)
          .font(.subheadline)
        Spacer()
      }
      
      GeometryReader { geometry in
        HStack(spacing: .zero) {
          Color(hexValue: viewModel.home.theme.mainColorCode)
            .frame(width: viewModel.getStatsBarWidth(screenWidth: geometry.size.width, isHome: true))
          Color(hexValue: viewModel.away.theme.mainColorCode)
            .frame(width: viewModel.getStatsBarWidth(screenWidth: geometry.size.width, isHome: false))
        }
        .clipShape(.rect(cornerRadius: 4))
        .frame(height: 8)
      }
      .padding(.horizontal, 32)
    }
  }
}

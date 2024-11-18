import SwiftUI

@MainActor
public class PlayerStatCellViewModel {
  public let statType: StatType
  public let playerStatsItem: PlayerStats
  public let order: Int

  public var imageWidth: CGFloat {
    switch order {
    case 0:
      64
    case 1:
      56
    case 2:
      48
    default:
      40
    }
  }

  public init(statType: StatType, playerStatsItem: PlayerStats, order: Int) {
    self.statType = statType
    self.playerStatsItem = playerStatsItem
    self.order = order
  }
}

public struct PlayerStatCell: View {
  let viewModel: PlayerStatCellViewModel

  public init(viewModel: PlayerStatCellViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    HStack(spacing: 16.0) {
      let imageURL = URL(string: viewModel.playerStatsItem.statistics.first?.team.logo ?? "")
      
      AsyncImage(url: imageURL) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: viewModel.imageWidth, height: viewModel.imageWidth)
          .padding(.vertical, 8)
      } placeholder: {
        Image(systemName: "circle")
          .resizable()
          .scaledToFit()
          .frame(width: viewModel.imageWidth, height: viewModel.imageWidth)
          .padding(.vertical, 8)
      }
      Text(viewModel.playerStatsItem.player.name)
        .foregroundColor(Color.white)
        .font(.headline)
      Spacer()
      switch viewModel.statType {
      case .topScorers:
        Text("\(viewModel.playerStatsItem.statistics.first?.goals.total ?? 0)")
          .foregroundColor(Color.white)
          .font(.headline)
      case .topAssists:
        Text("\(viewModel.playerStatsItem.statistics.first?.goals.assists ?? 0)")
          .foregroundColor(Color.white)
          .font(.headline)
      }
    }
    .padding(.horizontal, 16)
    .background {
      Color(hexValue: viewModel.playerStatsItem.statistics.first?.team.theme.mainColorCode ?? "aaaaaa").opacity(0.4)
    }
    .clipShape(.rect(cornerRadius: 8))
  }
}

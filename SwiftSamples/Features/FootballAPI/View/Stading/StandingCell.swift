import SwiftUI

public struct StandingCell: View {
  public let standingItem: Standing
  
  public init(standingItem: Standing) {
    self.standingItem = standingItem
  }
  
  public var body: some View {
    
    let imageURL = URL(string: standingItem.team.logo)
    
    HStack(spacing: 8) {
      Text(standingItem.rank.description)
        .foregroundColor(Color.white)
        .font(.title)
        .frame(width: 48)
      
      AsyncImage(url: imageURL) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
      } placeholder: {
        Image(systemName: "circle")
      }

      Text(standingItem.team.name)
        .foregroundColor(Color.white)
        .font(.subheadline)
      Spacer()
      HStack(spacing: 16) {
        Text(standingItem.all.played.description)
          .foregroundColor(Color.white)
          .font(.headline)
          .frame(width: 32)
        Text(standingItem.goalsDiff.description)
          .foregroundColor(Color.white)
          .font(.headline)
          .frame(width: 32)
        Text(standingItem.points.description)
          .foregroundColor(Color.white)
          .font(.headline)
          .frame(width: 32)
      }
      .padding(.trailing, 16)
      
    }
    .frame(height: 72)
    .background {
      LinearGradient(
        gradient: Gradient(colors: [
          Color(hexValue: standingItem.team.theme.mainColorCode),
          Color(hexValue: "1a1a1a"),
          Color(hexValue: "1a1a1a"),
          Color(hexValue: "1a1a1a"),
          Color(hexValue: "1a1a1a"),
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
    }
    .clipShape(.rect(cornerRadius: 8))
  }
}

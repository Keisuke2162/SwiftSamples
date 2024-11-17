import SwiftUI

public struct FixturesCell: View {
  public let fixture: Fixture
  
  public init(fixture: Fixture) {
    self.fixture = fixture
  }
  
  public var body: some View {
    HStack(spacing: .zero) {
      HStack {
        AsyncImage(url: URL(string: fixture.teams.home.logo)!) { image in
          image
            .resizable()
            .frame(width: 56, height: 56)
            .aspectRatio(contentMode: .fill)
            .padding(.leading, 32)
            .padding(.vertical, 16)
        } placeholder: {
          Image(systemName: "circle")
            .resizable()
            .frame(width: 56, height: 56)
            .aspectRatio(contentMode: .fill)
            .padding(.leading, 32)
            .padding(.vertical, 16)
        }
        
        Spacer()
        Text(fixture.goals.home?.description ?? "")
          .foregroundColor(Color.white)
          .font(.headline)
          .padding(.trailing, 16)
      }
      
      Text("-")
        .foregroundColor(Color.white)
        .font(.headline)
        .padding(.horizontal, 8)
      
      HStack {
        Text(fixture.goals.away?.description ?? "")
          .foregroundColor(Color.white)
          .font(.headline)
          .padding(.leading, 16)
        Spacer()
        
        AsyncImage(url: URL(string: fixture.teams.away.logo)!) { image in
          image
            .resizable()
            .frame(width: 56, height: 56)
            .aspectRatio(contentMode: .fill)
            .padding(.trailing, 32)
            .padding(.vertical, 16)
        } placeholder: {
          Image(systemName: "circle")
            .resizable()
            .frame(width: 56, height: 56)
            .aspectRatio(contentMode: .fill)
            .padding(.trailing, 32)
            .padding(.vertical, 16)
        }
      }
    }
    .background {
      LinearGradient(
        gradient: Gradient(colors: [
          Color(hexValue: fixture.teams.home.theme.mainColorCode),
          Color(hexValue: fixture.teams.away.theme.mainColorCode)
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}

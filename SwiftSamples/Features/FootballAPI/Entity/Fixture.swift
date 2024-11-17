import Foundation

public struct FixturesItem: Codable {
  public let response: [Fixture]
  
  public var groupedItems: [String: [Fixture]] {
    Dictionary(grouping: response) { item in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: item.fixture.date)
    }
  }
  
  public var dateKeys: [String] {
    groupedItems.keys.sorted()
  }
}

public struct Fixture: Identifiable, Codable, Equatable {
  public static func == (lhs: Fixture, rhs: Fixture) -> Bool {
    lhs.id == rhs.id
  }
  public var id: Int {
    fixture.id
  }
  public let fixture: FixtureItem
  public let teams: FixtureTeams
  public let goals: FixtureGoals

  public init(fixture: FixtureItem, teams: FixtureTeams, goals: FixtureGoals) {
    self.fixture = fixture
    self.teams = teams
    self.goals = goals
  }
}

public struct FixtureItem: Codable {
  public let id: Int
  public let date: Date
  public let status: FixtureStatus
}

public struct FixtureStatus: Codable {
  public let short: String
}

public struct FixtureTeams: Codable {
  public let home: FixtureTeam
  public let away: FixtureTeam
}

public struct FixtureTeam: Codable, Sendable {
  public let id: Int
  public let name: String
  public let logo: String
  public let winner: Bool?
  
  public var theme: ClubTheme {
    ClubTheme(rawValue: id) ?? .other
  }
}

public struct FixtureGoals: Codable {
  public let home: Int?
  public let away: Int?
}

public struct FixtureScore: Codable {
  public let halftime: FixtureGoals
  public let fulltime: FixtureGoals
  public let extratime: FixtureGoals
  public let penalty: FixtureGoals
  public var secondHalf: FixtureGoals {
    guard let halftimeHome = halftime.home, let fulltimeHome =  fulltime.home , let halftimeAway = halftime.away, let fulltimeAway = fulltime.away else { return .init(home: nil, away: nil) }
    return .init(home: fulltimeHome - halftimeHome, away: fulltimeAway - halftimeAway)
  }
}

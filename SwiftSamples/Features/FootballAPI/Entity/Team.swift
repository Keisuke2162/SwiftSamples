import Foundation

public struct Team: Codable, Sendable {
  public let id: Int
  public let name: String
  public let logo: String
  
  public var theme: ClubTheme {
    ClubTheme(rawValue: id) ?? .other
  }
}

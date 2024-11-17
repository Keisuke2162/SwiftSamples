import Foundation

final class FootballAPIClient {
  static let shared = FootballAPIClient()

//  var decoder: JSONDecoder {
//    let decoder = JSONDecoder()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//    decoder.dateDecodingStrategy = .formatted(dateFormatter)
//    return decoder
//  }
  
  private init() {}

  // 順位表取得
  func fetchStandings(leagueType: LeagueType, useLocalJson: Bool) async throws -> [Standing] {
    let data: Data
    
    if useLocalJson {
      guard let fileURL = Bundle.main.url(forResource: leagueType.standingResource, withExtension: "json") else {
        throw FootballAPIError.notJsonFile
      }

      data = try Data(contentsOf: fileURL)
    } else {
      var components = URLComponents(string: "https://v3.football.api-sports.io/standings")!
      components.queryItems = [
        .init(name: "season", value: "2022"),
        .init(name: "league", value: leagueType.id)
      ]
      var request = URLRequest(url: components.url!)
      request.setValue(APIKey.footballAPIKey, forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"

      (data, _) = try await URLSession.shared.data(for: request)
    }

    do {
      let item = try JSONDecoder().decode(StandingsItem.self, from: data)
      guard let standings = item.response.first?.league.standings.first else {
        throw FootballAPIError.noData
      }
      return standings
    } catch {
      throw FootballAPIError.encodeError
    }
  }
  
  // 試合日程取得
  func fetchFixtures(leagueType: LeagueType, useLocalJson: Bool) async throws -> FixturesItem {
    let data: Data
    
    if useLocalJson {
      guard let fileURL = Bundle.main.url(forResource: leagueType.fixturesResource, withExtension: "json") else {
        throw FootballAPIError.notJsonFile
      }

      data = try Data(contentsOf: fileURL)
    } else {
      var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures")!
      components.queryItems = [
        .init(name: "season", value: "2022"),
        .init(name: "league", value: leagueType.id)
      ]
      var request = URLRequest(url: components.url!)
      request.setValue(APIKey.footballAPIKey, forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"

      (data, _) = try await URLSession.shared.data(for: request)
    }
    
    // print(String(data: data, encoding: .utf8) ?? "Invalid JSON")

    do {
      let decoder = JSONDecoder()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      decoder.dateDecodingStrategy = .formatted(dateFormatter)
      
      let item = try decoder.decode(FixturesItem.self, from: data)
      return item
    } catch {
      throw FootballAPIError.encodeError
    }
  }

  // 試合詳細取得
  func fetchFixtureDetail(teamID: Int, fixtureID: Int, isHome: Bool, useLocalJson: Bool) async throws -> FixtureDetail {
    let data: Data
    
    if useLocalJson {
      let resource = isHome ? "football_api_statistics_2024_98_282" : "football_api_statistics_2024_98_287"
      guard let fileURL = Bundle.main.url(forResource: resource, withExtension: "json") else {
        throw FootballAPIError.notJsonFile
      }

      data = try Data(contentsOf: fileURL)
    } else {
      var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures/statistics")!
      components.queryItems = [
        .init(name: "fixture", value: String(fixtureID)),
        .init(name: "team", value: String(teamID))
      ]
      var request = URLRequest(url: components.url!)
      request.setValue(APIKey.footballAPIKey, forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"

      (data, _) = try await URLSession.shared.data(for: request)
    }

    do {
      let decoder = JSONDecoder()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      decoder.dateDecodingStrategy = .formatted(dateFormatter)
      
      let item = try decoder.decode(FixtureDetailItem.self, from: data)
      guard let standings = item.response.first else {
        throw FootballAPIError.noData
      }
      return standings
    } catch {
      throw FootballAPIError.encodeError
    }
  }
  
  // 得点ランキング取得
  func fetchTopScorers(leagueType: LeagueType, useLocalJson: Bool) async throws -> [PlayerStats] {
    let data: Data
    
    if useLocalJson {
      guard let fileURL = Bundle.main.url(forResource: leagueType.topScorerResource, withExtension: "json") else {
        throw FootballAPIError.notJsonFile
      }

      data = try Data(contentsOf: fileURL)
    } else {
      var components = URLComponents(string: "https://v3.football.api-sports.io/players/topscorers")!
      components.queryItems = [
        .init(name: "season", value: "2022"),
        .init(name: "league", value: leagueType.id)
      ]
      var request = URLRequest(url: components.url!)
      request.setValue(APIKey.footballAPIKey, forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"

      (data, _) = try await URLSession.shared.data(for: request)
    }

    do {
      let decoder = JSONDecoder()
      let item = try decoder.decode(PlayerStatsItem.self, from: data)
      return item.response
    } catch {
      throw FootballAPIError.encodeError
    }
  }

  // アシストランキング取得
  func fetchTopAssists(leagueType: LeagueType, useLocalJson: Bool) async throws -> [PlayerStats] {
    let data: Data
    
    if useLocalJson {
      guard let fileURL = Bundle.main.url(forResource: leagueType.topAssistResource, withExtension: "json") else {
        throw FootballAPIError.notJsonFile
      }

      data = try Data(contentsOf: fileURL)
    } else {
      var components = URLComponents(string: "https://v3.football.api-sports.io/players/topassists")!
      components.queryItems = [
        .init(name: "season", value: "2022"),
        .init(name: "league", value: leagueType.id)
      ]
      var request = URLRequest(url: components.url!)
      request.setValue(APIKey.footballAPIKey, forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"

      (data, _) = try await URLSession.shared.data(for: request)
    }

    do {
      let decoder = JSONDecoder()
      let item = try decoder.decode(PlayerStatsItem.self, from: data)
      return item.response
    } catch {
      throw FootballAPIError.encodeError
    }
  }

  enum FootballAPIError: Error {
    case noData
    case notJsonFile
    case invalidURL
    case encodeError
  }
}

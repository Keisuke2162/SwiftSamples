//
//  FootballAPIClient.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/17.
//

final class FootballAPIClient {
  static let shared = FootballAPIClient()
  
  private init() {}

  // 順位表取得
  func fetchStandings() async throws {
    
  }
  
  // 試合日程取得
  func fetchFixtures() async throws {
    
  }
  
  // 得点ランキング取得
  func fetchTopScorers() async throws {
    
  }

  // アシストランキング取得
  func fetchTopAssists() async throws {
    
  }

  enum FootballAPIError: Error {
    case invalidURL
    case encodeError
  }
}


/*
 final class APIClient {
     static let shared = APIClient()

     private init() {}

     func fetchWeather() async throws -> WeatherResponse {
         guard let url = URL(string: "https://api.example.com/weather") else {
             throw APIError.invalidURL
         }

         let (data, _) = try await URLSession.shared.data(from: url)
         return try JSONDecoder().decode(WeatherResponse.self, from: data)
     }

     enum APIError: Error, LocalizedError {
         case invalidURL
         case noData

         var errorDescription: String? {
             switch self {
             case .invalidURL: return "Invalid URL"
             case .noData: return "No data received"
             }
         }
     }
 }
 */

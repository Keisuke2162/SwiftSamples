



import SwiftUI

@MainActor
public class FixturesViewModel: ObservableObject {
  @Published var fixtures: [Fixture] = []
  @Published var isLoading = false
  @Published var selectedDateIndex: Int = 0
  let leagueType: LeagueType
  let isUseJSON: Bool
  var groupedItem: [String: [Fixture]] = [:]
  var dateKeys: [String] = []
  
  public init(leagueType: LeagueType, isUseJSON: Bool) {
    self.leagueType = leagueType
    self.isUseJSON = isUseJSON
  }
  
  func fetchFixtures() async {
    isLoading = true
    do {
      let fixturesResponse = try await FootballAPIClient.shared.fetchFixtures(leagueType: leagueType, useLocalJson:isUseJSON)
      self.fixtures = fixturesResponse.response
      self.groupedItem = fixturesResponse.groupedItems
      self.dateKeys = fixturesResponse.dateKeys
    } catch {
      // TODO: Error画面表示
    }
    isLoading = false
  }

  func showPreviousDate() {
    if selectedDateIndex > 0 {
      selectedDateIndex -= 1
    }
  }

  func showNextDate() {
    if selectedDateIndex < dateKeys.count - 1 {
      selectedDateIndex += 1
    }
  }
}

public struct FixturesView: View {
  @StateObject private var viewModel: FixturesViewModel
  
  public init(leagueType: LeagueType, isUseJSON: Bool) {
    _viewModel = StateObject(wrappedValue: FixturesViewModel(leagueType: leagueType, isUseJSON: isUseJSON))
  }

  public var body: some View {
    VStack(spacing: .zero) {
      if viewModel.fixtures.isEmpty {
        Color.clear
      } else {
        // MEMO: header部分component化しても良さそう
        HStack {
          Spacer()
          Button {
            viewModel.showPreviousDate()
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(Color.white)
          }
          Spacer()
          Text(viewModel.dateKeys.isEmpty ? "" : viewModel.dateKeys[viewModel.selectedDateIndex])
            .foregroundColor(Color.white)
            .font(.headline)
            .padding(.vertical, 16)
          Spacer()
          Button {
            viewModel.showNextDate()
          } label: {
            Image(systemName: "chevron.right")
              .foregroundColor(Color.white)
          }
          Spacer()
        }
        .background(viewModel.leagueType.backgroundColor)
        
        ScrollView {
          VStack(spacing: 16) {
            Spacer().frame(height: 16)
            ForEach(viewModel.groupedItem[viewModel.dateKeys[viewModel.selectedDateIndex]] ?? []) { item in
              NavigationLink { EmptyView() } label: { FixturesCell(fixture: item) }
                .padding(.horizontal, 24)
            }
            Spacer().frame(height: 120)
          }
        }
      }
    }
    .background(viewModel.leagueType.backgroundColor)
    .task {
      await viewModel.fetchFixtures()
    }
  }
}

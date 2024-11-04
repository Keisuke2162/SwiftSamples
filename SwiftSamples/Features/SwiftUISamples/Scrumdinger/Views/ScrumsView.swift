//
//  ScrumsView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/03.
//

import SwiftUI

struct ScrumsView: View {
  @Binding var scrums: [DailyScrum]
  @State private var isPresentingNewScrumView = false
  
  var body: some View {
    List($scrums) { $scrum in
      NavigationLink {
        ScrumDetailView(scrum: $scrum)
      } label: {
        CardView(scrum: scrum)
      }
      .listRowBackground(scrum.theme.mainColor)
    }
    .navigationTitle("Daily Scrums")
    .toolbar {
      Button {
        isPresentingNewScrumView = true
      } label: {
        Image(systemName: "plus")
      }
      .accessibilityLabel("New Scrum")
    }
    .sheet(isPresented: $isPresentingNewScrumView) {
      NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
    }
  }
}

#Preview {
  ScrumsView(scrums: .constant(DailyScrum.sampleData))
}

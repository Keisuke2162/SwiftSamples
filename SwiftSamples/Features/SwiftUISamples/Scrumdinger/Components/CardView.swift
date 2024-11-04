//
//  CardView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/02.
//

import SwiftUI

struct CardView: View {
  let scrum: DailyScrum
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(scrum.title)
        .font(.headline)
        .accessibilityAddTraits(.isHeader)
      Spacer()
      HStack {
        Label("\(scrum.attendees.count)", systemImage: "person.3")
          .accessibilityLabel("\(scrum.attendees.count) attendees")
        Spacer()
        Label("\(scrum.lengthInMinutes)", systemImage: "clock")
          .accessibilityLabel("\(scrum.lengthInMinutes) minute meeting")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(scrum.theme.accentColor)
  }
}

#Preview(traits: .fixedLayout(width: 400, height: 60)) {
  var scrum = DailyScrum.sampleData[0]
  CardView(scrum: scrum)
    .background(scrum.theme.mainColor)
}


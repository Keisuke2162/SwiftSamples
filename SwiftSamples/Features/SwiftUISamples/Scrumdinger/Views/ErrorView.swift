//
//  ErrorView.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/09.
//

import SwiftUI

struct ErrorView: View {
  let errorWrapper: ErrorWrapper
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      Text("An error has occurred!")
        .font(.title)
        .padding(.bottom)
      Text(errorWrapper.error.localizedDescription)
        .font(.headline)
      Text(errorWrapper.guidance)
        .font(.caption)
        .padding(.top)
      Spacer()
    }
    .padding()
    .background(.ultraThinMaterial)
    .cornerRadius(16)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Dismiss") {
          dismiss()
        }
      }
    }
  }
}

#Preview {
  enum SampleError: Error {
    case errorRequired
  }
  
  var wrapper: ErrorWrapper {
    ErrorWrapper(error: SampleError.errorRequired, guidance: "test")
  }
  
  return ErrorView(errorWrapper: wrapper)
}

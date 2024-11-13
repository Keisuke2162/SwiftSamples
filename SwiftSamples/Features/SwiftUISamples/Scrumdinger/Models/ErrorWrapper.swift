//
//  ErrorWrapper.swift
//  SwiftSamples
//
//  Created by Kei on 2024/11/09.
//

import Foundation

struct ErrorWrapper: Identifiable {
  let id: UUID
  let error: Error
  let guidance: String
  
  
  init(id: UUID = UUID(), error: Error, guidance: String) {
    self.id = id
    self.error = error
    self.guidance = guidance
  }
}


//
//  extension+Data.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

extension Data {
  mutating func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

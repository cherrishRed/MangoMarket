//
//  Currency.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
     case KRW = "KRW"
     case USD = "USD"
  
  var symbol: String {
    switch self {
      case .KRW:
        return "￦"
      case .USD:
        return "$"
    }
  }
 }

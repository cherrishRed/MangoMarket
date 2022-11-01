//
//  extension+Double.swift
//  MangoMarket
//
//  Created by RED on 2022/11/01.
//

import Foundation

extension Double {
  func formatPrice(currency: Currency) -> String {
    let numberFormatter = NumberFormatter()
    var formattedPrice: String
    
    switch currency {
      case .KRW:
        numberFormatter.numberStyle = .none
        formattedPrice = numberFormatter.string(from: self as NSNumber) ?? "가격 정보 없음"
      case .USD:
        numberFormatter.maximumFractionDigits = 2
        formattedPrice = numberFormatter.string(from: self as NSNumber) ?? "가격 정보 없음"
      default:
        formattedPrice = "가격 정보 없음"
    }
    
    return formattedPrice
  }
  
}

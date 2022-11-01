//
//  ProductListCellModel.swift
//  MangoMarket
//
//  Created by RED on 2022/11/01.
//

import Foundation

class ProductListCellViewModel: ObservableObject {
  var product: ProductDetail
  
  init(product: ProductDetail) {
    self.product = product
  }
  
  var salePercent: String {
      guard let price = product.price else {
        return "0%"
      }
      guard let discountedPrice = product.discountedPrice else {
        return "0%"
      }
      
      if discountedPrice == 0 || price == 0 {
        return "0%"
      } else {
        let salePercent = discountedPrice / price
        return "\(Int(round(salePercent*100)))%"
      }
  }
  
  var noSale: Bool {
    return salePercent == "0%" ? true : false
  }
  
  var thumbnailURL: String? {
    return product.thumbnail?.absoluteString
  }
  
  var productName: String {
    return product.name ?? "이름없음"
  }
  
  var productPrice: String {
    guard let currency = product.currency else { return "환률 정보 오류"
    }
    return product.price?.formatPrice(currency: currency) ?? "가격정보 없음"
  }
  
  var productDiscountedPrice: String {
    guard let currency = product.currency else { return "환률 정보 오류"
    }
    return product.discountedPrice?.formatPrice(currency: currency) ?? "가격정보 없음"
  }
  
  var outOfStock: Bool {
    return product.stock == 0 ? true : false
  }
  
  var productStock: String {
    return "\(product.stock ?? 0)" 
  }
}

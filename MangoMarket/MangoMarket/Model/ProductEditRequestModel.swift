//
//  ProductEditRequestModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

struct ProductEditRequestModel: Encodable {
  var name: String?
  var descriptions: String?
  var price: Double?
  var currency: Currency?
  var discountedPrice: Double?
  var stock: Int?
  var secret: String?
  var boundary: String? = UUID().uuidString
  
  enum CodingKeys: String, CodingKey {
    case name, price, currency, stock, secret
    case descriptions = "description"
  }
}

//
//  ProductDetailRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/19.
//

import Foundation

struct ProductDetailRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(productsId: Int) {
    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = "/api/products/\(productsId)"
    self.method = .get
    self.queryParameters = nil
    self.bodyParameters = nil
    self.headers = [:]
  }
}

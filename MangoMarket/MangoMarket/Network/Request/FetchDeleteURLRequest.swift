//
//  FetchDeleteURLRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/21.
//

import Foundation

struct FetchDeleteURLRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(productsId: Int) {
    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = "/api/products/\(productsId)/archived"
    self.method = .get
    self.queryParameters = nil
    self.bodyParameters = nil
    self.headers = ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb"]
  }
}


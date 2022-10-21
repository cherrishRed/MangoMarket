//
//  DeleteProductRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

struct DeleteProductRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(deleteURL: String) {
    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = deleteURL
    self.method = .delete
    self.queryParameters = nil
    self.bodyParameters = nil
    self.headers = ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb"]
  }
}

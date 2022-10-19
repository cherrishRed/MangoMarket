//
//  EditProductRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/20.
//

import Foundation

struct EditProductRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(id: Int, product: ProductEditRequestModel) {
    let data = try? JSONEncoder().encode(product)

    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = "/api/products/\(id)"
    self.method = .patch
    self.queryParameters = nil
    self.bodyParameters = data
    self.headers = ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb",
                    "Content-Type": "application/json"]
  }
  
}

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
  
  init(productsId: Int, secret: String?) {
    let body = DeleteURLRequestModel(secret: secret)
    let data = try? JSONEncoder().encode(body)
    
    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = "/api/products/\(productsId)/archived"
    self.method = .post
    self.queryParameters = nil
    self.bodyParameters = data
    self.headers = ["identifier": UserInfomation.shared.identifier,
                    "Content-Type": "application/json"]
  }
}


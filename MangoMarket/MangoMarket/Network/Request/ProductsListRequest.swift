//
//  ProductsListRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/18.
//

import Foundation

struct ProductsListRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(baseURL: String = "https://openmarket.yagom-academy.kr",
       path: String = "/api/products?",
       method: HTTPMethod = .get,
       pageNumber: Int = 1,
       itemsPerPage: Int = 100,
       searchValue: String = "",
       bodyParameters: Encodable? = nil,
       headers: [String : String] = [:]) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.queryParameters = ["page_no": "\(pageNumber)", "items_per_page": "\(itemsPerPage)", "search_value": searchValue]
    self.bodyParameters = bodyParameters
    self.headers = headers
  }
}

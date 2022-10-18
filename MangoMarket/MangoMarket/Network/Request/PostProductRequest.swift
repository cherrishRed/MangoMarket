//
//  PostProductRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/19.
//

import Foundation

struct PostProductRequest: Requestable {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var queryParameters: [String : String]?
  var bodyParameters: Encodable?
  var headers: [String : String]
  
  init(forms: [FormData], boundary: String) {
    self.baseURL = "https://openmarket.yagom-academy.kr"
    self.path = "/api/products"
    self.method = .post
    self.queryParameters = [:]
    self.bodyParameters = FormDataGenerator(boundary: boundary).createMutiPartFormData(forms)
    self.headers = ["identifier": "81da9d11-4b9d-11ed-a200-81a344d1e7cb",
                    "Content-Type": "multipart/form-data; boundary=\(boundary)"]
  }
}

//
//  Requestable.swift
//  MangoMarket
//
//  Created by RED on 2022/10/18.
//

import Foundation

protocol Requestable {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queryParameters: [String: String]? { get }
  var bodyParameters: Encodable? { get }
  var headers: [String: String] { get }
}

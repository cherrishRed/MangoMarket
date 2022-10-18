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

extension Requestable {
  func makeURLComponents() -> URLComponents? {
    var urlComponents = URLComponents(string: baseURL + path)
    let queries = queryParameters?.map { URLQueryItem(name: $0, value: $1) } ?? []
    urlComponents?.queryItems = queries
    
    return urlComponents
  }
  
  func makeURLRequest() -> URLRequest? {
    guard let url = makeURLComponents()?.url else {
      return nil
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    
    headers.forEach { (key: String, value: String) in
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    
    if bodyParameters != nil {
      let body = bodyParameters as? Data
      urlRequest.httpBody = body
    }
    
    return urlRequest
  }
}

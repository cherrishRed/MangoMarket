//
//  extension+URLSession.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

extension URLSession: URLSessionProtocol {
  func dataTask(with urlRequset: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    return dataTask(with: urlRequset, completionHandler: completionHandler) as URLSessionDataTask
  }
  
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
  }
}

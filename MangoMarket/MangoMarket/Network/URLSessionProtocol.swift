//
//  URLSessionProtocol.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

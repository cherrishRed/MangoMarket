//
//  APIService.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import Foundation

final class APIService {
  private let urlSession: URLSessionProtocol
  
  init(urlSession: URLSessionProtocol = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  func request(_ request: URLRequest) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: request)
    try await checkError(response)
    return data
  }
  
  func fetchImage(_ urlString: String) async throws -> Data {
    
    guard let url = URL(string: urlString) else {
      throw URLError.imageURLError
    }
    
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    try await checkError(response)
    
    return data
  }
  
  func makeFormData(productRequest: ProductRequest) -> FormData {
    let data = try? JSONEncoder().encode(productRequest)
    return FormData(type: .json, name: "params", data: data)
  }
  
  func makeImageFormData(productRequest: ProductRequest) -> [FormData] {
    guard let imageInfos = productRequest.imageInfos else { return [] }
    return imageInfos.map { FormData(type: .jpeg, name: "images", filename: $0.fileName, data: $0.data) }
  }
  
  
  private func checkError(_ response: URLResponse?) async throws {
      guard let response = response as? HTTPURLResponse else {
        throw NetworkError.responseError
      }
      
      guard (200..<300).contains(response.statusCode) else {
        throw NetworkError.invalidHttpStatusCodeError(statusCode: response.statusCode)
      }
  }
}

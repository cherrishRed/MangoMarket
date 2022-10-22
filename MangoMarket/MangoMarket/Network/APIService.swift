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
  
  func request(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    
          self.checkError(with: data, response, error) { result in
            switch result {
              case .success(let success):
                print("request 성공!")
                completion(Result.success(success))
              case .failure(let failure):
                print("request 실패")
                completion(Result.failure(failure))
            }
          }
        }
        task.resume()
  }

  func fetchImage(_ urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
    guard let url = URL(string: urlString) else {
      completion(.failure(URLError.imageURLError))
      return
    }

    guard let data = try? Data(contentsOf: url) else {
      completion(.failure(NetworkError.emptyDataError))
      return
    }

    completion(.success(data))
  }

  func makeFormData(productRequest: ProductRequest) -> FormData {
    let data = try? JSONEncoder().encode(productRequest)
    return FormData(type: .json, name: "params", data: data)
  }
  
  func makeImageFormData(productRequest: ProductRequest) -> [FormData] {
    guard let imageInfos = productRequest.imageInfos else { return [] }
    return imageInfos.map { FormData(type: .jpeg, name: "images", filename: $0.fileName, data: $0.data) }
  }
  
  
  private func checkError(
      with data: Data?,
      _ response: URLResponse?,
      _ error: Error?,
      completion: @escaping (Result<Data, Error>) -> ()
  ) {
      if let error = error {
          completion(.failure(error))
          return
      }
      
      guard let response = response as? HTTPURLResponse else {
          completion(.failure(NetworkError.responseError))
          return
      }
      
      guard (200..<300).contains(response.statusCode) else {
          completion(.failure(NetworkError.invalidHttpStatusCodeError(statusCode: response.statusCode)))
          return
      }
      
      guard let data = data else {
          completion(.failure(NetworkError.emptyDataError))
          return
      }
      
      completion(.success((data)))
  }
}

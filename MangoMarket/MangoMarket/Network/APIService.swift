//
//  APIService.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import Foundation

final class APIService {
  
  func retrieveProduct(completion: @escaping (Result<Data, Error>) -> ()) {
    let urlComponents = URLComponents(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100")!

    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      self.checkError(with: data, response, error) { result in
        switch result {
          case .success(let success):
            print("성공!")
            print(success)
            completion(Result.success(success))
          case .failure(let failure):
            print("실패ㅠㅠ")
            print(failure)
            completion(Result.failure(failure))
        }
      }
      
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
    }
    task.resume()
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

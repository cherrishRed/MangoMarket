//
//  APIService.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import Foundation

final class APIService {
  func retrieveProducts(completion: @escaping (Result<Data, Error>) -> ()) {
    guard let request = ProductsListRequest().makeURLRequest() else {
      return completion(.failure(URLError.urlRequestError))
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      self.checkError(with: data, response, error) { result in
        switch result {
          case .success(let success):
            print("product List 가져오기 성공!")
            completion(Result.success(success))
          case .failure(let failure):
            print("product List 가져오기 실패ㅠㅠ")
            completion(Result.failure(failure))
        }
      }
    }
    task.resume()
  }
  
  func retrieveProduct(id: Int, completion: @escaping (Result<Data, Error>) -> ()){
    guard let request = ProductDetailRequest(productsId: id).makeURLRequest() else {
      return completion(.failure(URLError.urlRequestError))
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      self.checkError(with: data, response, error) { result in
        switch result {
          case .success(let success):
            print("개별 데이터 가져오기 성공!")
            print(success)
            completion(Result.success(success))
          case .failure(let failure):
            print("개별 데이터 가져오기 실패ㅠㅠ")
            print(failure)
            completion(Result.failure(failure))
        }
      }
    }
    task.resume()
  }
  
  func postProducts(newProduct: ProductRequest) {
    var forms: [FormData] = []
    forms.append(makeFormData(productRequest: newProduct))
    forms.append(contentsOf: makeImageFormData(productRequest: newProduct))
    
    guard let request = PostProductRequest(forms: forms,
                                           boundary: newProduct.boundary!).makeURLRequest() else {
      return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      self.checkError(with: data, response, error) { result in
        switch result {
          case .success(let success):
            print("포스트 성공!")
//            completion(Result.success(success))
          case .failure(let failure):
            print("포스트 실패ㅠㅠ")
//            completion(Result.failure(failure))
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

extension Data {
  mutating func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

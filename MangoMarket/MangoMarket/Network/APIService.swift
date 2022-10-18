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
    let urlComponents = URLComponents(string: "https://openmarket.yagom-academy.kr/api/products/\(id)")!
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    
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
      
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
    }
    task.resume()
  }
  
  func postProducts(newProduct: ProductRequest) {
    let body = createBody(params: newProduct)
    let boundary = "\(newProduct.boundary!)"
    
    var request = URLRequest(url: URL(string: "https://openmarket.yagom-academy.kr/api/products")!,timeoutInterval: Double.infinity)
    request.addValue("81da9d11-4b9d-11ed-a200-81a344d1e7cb", forHTTPHeaderField: "identifier")
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    request.httpMethod = "POST"
    request.httpBody = body
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      self.checkError(with: data, response, error) { result in
        switch result {
          case .success(let success):
            print("포스트 성공!")
            print(success)
//            completion(Result.success(success))
          case .failure(let failure):
            print("포스트 실패ㅠㅠ")
            print(failure)
//            completion(Result.failure(failure))
        }
      }
    }
    
    task.resume()
  }
  
  private func createBody(params: ProductRequest) -> Data? {
       var body = Data()
       let newline = "\r\n"
       let boundaryPrefix = "--\(params.boundary!)\r\n"
       let boundarySuffix = "\r\n--\(params.boundary!)--\r\n"
       guard let jsonData = try? JSONEncoder().encode(params) else {
           return nil
       }
    
        print("========================================")
       
       body.appendString(boundaryPrefix)
        print(boundaryPrefix)
       body.appendString("Content-Disposition: form-data; name=\"params\"")
       body.appendString(newline)
       body.appendString("Content-Type: application/json")
       body.appendString(newline)
       body.appendString(newline)
       body.append(jsonData)
       body.appendString(newline)
       
       guard let images = params.imageInfos else {
           return nil
       }

       for image in images {
           body.appendString(boundaryPrefix)
           body.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName).jpeg\"")
           body.appendString(newline)
           body.appendString("Content-Type: image/jpeg")
           body.appendString(newline)
           body.appendString(newline)
           body.append(image.data)
           body.appendString(newline)
       }

       body.appendString(boundarySuffix)
       print("========================================")
       print("\(body)")
       
       return body
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

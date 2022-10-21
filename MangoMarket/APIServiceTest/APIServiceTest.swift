//
//  APIServiceTest.swift
//  APIServiceTest
//
//  Created by RED on 2022/10/22.
//

import XCTest
@testable import MangoMarket

final class APIServiceTest: XCTestCase {
  var sut: APIService!
  
  override func setUpWithError() throws {
    sut = APIService(urlSession: StubURLSession())
    
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_request호출시_mockresult를_호출하는지() {
    guard let request = ProductsListRequest().makeURLRequest() else {
      return
    }
    sut.request(request) { result in
      switch result {
        case .success(let success):
          let expectation = String(data: success, encoding: .utf8)
          XCTAssertEqual(expectation, "mockResult")
        case .failure(let failure):
          print(failure)
          XCTFail()
      }
    }
  }
}

//MARK: Stub test
final class StubURLSession: URLSessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    let successResponse = HTTPURLResponse(
      url: URL(string: "http://test")!,
      statusCode: 200,
      httpVersion: "2",
      headerFields: nil
    )
    let completion: () -> Void = {}
    let sessionDataTask = StubURLSessionDataTask(resumeHandler: completion)
    
    do {
      let urlData = try Data(contentsOf: url)
      
      sessionDataTask.resumeHandler = {
        completionHandler(urlData, successResponse, nil)
      }
      
      return sessionDataTask
    } catch { }
    
    return sessionDataTask
  }
  
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    let mockResult: String = "mockResult"
    let data = mockResult.data(using: .utf8)
    
    let successResponse = HTTPURLResponse(
      url: URL(string: "http://success")!,
      statusCode: 200,
      httpVersion: "2",
      headerFields: nil
    )
    
    let completion: () -> Void = {}
    
    let sessionDataTask = StubURLSessionDataTask(resumeHandler: completion)
    
    sessionDataTask.resumeHandler = {
      completionHandler(data, successResponse, nil)
    }
    
    return sessionDataTask
  }
}

final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
  var resumeHandler: () -> Void
  
  init(resumeHandler: @escaping () -> Void) {
    self.resumeHandler = resumeHandler
  }
  
  func resume() {
    resumeHandler()
  }
}


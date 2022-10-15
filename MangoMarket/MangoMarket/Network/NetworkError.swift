//
//  NetworkError.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import Foundation

enum NetworkError: Error {
  case responseError
  case emptyDataError
  case invalidHttpStatusCodeError(statusCode: Int)
}

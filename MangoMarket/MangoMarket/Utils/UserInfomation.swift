//
//  UserInfomation.swift
//  MangoMarket
//
//  Created by RED on 2022/11/01.
//

import Foundation

class UserInfomation {
  static let shared: UserInfomation = UserInfomation()
  
  var userName: String = "red123"
  var identifier: String = "81da9d11-4b9d-11ed-a200-81a344d1e7cb"
  var secret: String = "bjv33pu73cbajp1"
  
  private init() {}
}

//
//  NavigationRouter.swift
//  MangoMarket
//
//  Created by RED on 2022/11/02.
//

import SwiftUI

protocol NavigationRouter {
  
  associatedtype V: View
  
  var transition: NavigationTranisitionStyle { get }
  
  @ViewBuilder
  func view() -> V
}

//
//  SearchViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import Foundation

class SearchViewModel: ObservableObject {
  @Published var searchText: String = ""
  var keywords: [String] = ["곰", "코딩", "텀블러", "강아지"]
  
  var searchTextIsEmpty: Bool {
    return searchText == ""
  }
  
  func tappedKeywordButton(_ keyword: String) {
    searchText = keyword
  }
}

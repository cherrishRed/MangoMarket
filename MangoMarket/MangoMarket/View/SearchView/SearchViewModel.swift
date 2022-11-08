//
//  SearchViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
  @Published var searchText: String = ""
  var subscriptions = Set<AnyCancellable>()
  var keywords: [String] = ["곰", "코딩", "텀블러", "강아지"]
  let productListViewModel = ProductListViewModel()
  
  init() {
    $searchText
      .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { (_) in
      } receiveValue: { [self] (searchValue) in
        print(searchValue)
        productListViewModel.changeSearchValue(searchValue)
      }.store(in: &subscriptions)
  }
  
  deinit {
    for subscription in subscriptions {
      subscription.cancel()
    }
  }
  
  var searchTextIsEmpty: Bool {
    return searchText == ""
  }
  
  func tappedKeywordButton(_ keyword: String) {
    searchText = keyword
  }
}

//
//  ProductListViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/18.
//

import Foundation

final class ProductListViewModel: ObservableObject {
  @Published var onlyImage: Bool
  @Published var products: [ProductDetail]
  @Published var searchValue: String
  let apiService = APIService()
  
  var productIsEmpty: Bool {
    return products.isEmpty
  }
  
  init(onlyImage: Bool = false, products: [ProductDetail] = [], searchValue: String = "") {
    self.onlyImage = onlyImage
    self.products = products
    self.searchValue = searchValue
  }
  
  func retrieveProducts(searchValue: String = "") {
    guard let request = ProductsListRequest(searchValue: searchValue).makeURLRequest() else {
      return
    }
    apiService.request(request) { [weak self] result in
      switch result {
        case .success(let success):
          do {
            let productList = try JSONDecoder().decode(ProductList.self, from: success)
            DispatchQueue.main.async {
              self?.products = productList.items ?? []
            }
          } catch {
            DispatchQueue.main.async {
              self?.products = []
            }
            print("디코드 에러")
            print(error)
          }
        case .failure(let failure):
          print("오류!!!")
          print(failure)
      }
    }
  }
  
  func changeSearchValue(_ searchValue: String = "") {
    self.searchValue = searchValue
  }
}

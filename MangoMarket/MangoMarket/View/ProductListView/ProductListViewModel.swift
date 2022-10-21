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
  let apiService = APIService()
  
  init(onlyImage: Bool = false, products: [ProductDetail] = []) {
    self.onlyImage = onlyImage
    self.products = products
  }
  
  func retrieveProducts() {
    guard let request = ProductsListRequest().makeURLRequest() else {
      return
    }
    apiService.request(request) { result in
      switch result {
        case .success(let success):
          do {
            let productList = try JSONDecoder().decode(ProductList.self, from: success)
            DispatchQueue.main.async {
              self.products = productList.items ?? []
            }
          } catch {
            print("디코드 에러")
          }
        case .failure(let failure):
          print("오류!!!")
          print(failure)
      }
    }
  }
}

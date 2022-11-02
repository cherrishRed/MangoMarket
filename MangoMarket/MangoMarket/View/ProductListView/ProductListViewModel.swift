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
  @Published var showAlert = false
  var deleteReady: Int? = nil
  let layout: Layout
  let apiService = APIService()
  
  var productIsEmpty: Bool {
    return products.isEmpty
  }
  
  enum Layout {
    case grid
    case row
  }
  
  init(onlyImage: Bool = false, products: [ProductDetail] = [], searchValue: String = "", layout: Layout = .grid) {
    self.onlyImage = onlyImage
    self.products = products
    self.searchValue = searchValue
    self.layout = layout
  }
  
  func retrieveProducts() {
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
  
  func tappedDeleteButton(id: Int) {
    print(id)
    deleteReady = id
    showAlert = true
  }
  
  func deleteProduct() {
    guard let productId = deleteReady else {
      return
    }
    guard let request = FetchDeleteURLRequest(productsId: productId, secret: UserInfomation.shared.secret).makeURLRequest() else {
      return
    }
    
    apiService.request(request) { result in
      switch result {
        case .success(let success):
          guard let deleteURL = String(data: success, encoding: .utf8) else {
            return
          }
          guard let deleteRequest = DeleteProductRequest(deleteURL: deleteURL).makeURLRequest() else { return }
          self.apiService.request(deleteRequest) { deleteResult in
            switch deleteResult {
              case .success(_):
                self.retrieveProducts()
                print("삭제 성공")
              case .failure(_):
                print("삭제 실패")
            }
          }
        case .failure(_):
          print("fail")
      }
    }
  }
}

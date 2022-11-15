//
//  ProductListViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/18.
//

import SwiftUI

final class ProductListViewModel: ObservableObject {
  @Published var onlyImage: Bool
  @Published var products: [ProductDetail]
  @Published var searchValue: String
  @Published var showAlert = false
  @Published var pageNumber: Int
  
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
    self.pageNumber = 1
  }
  
  @MainActor
  func retrieveProducts(pageNumber: Int = 1, itemsPerPage: Int = 10) async {
    guard let request = ProductsListRequest(pageNumber: pageNumber,
                                            itemsPerPage: itemsPerPage,
                                            searchValue: searchValue).makeURLRequest() else {
      return
    }
    
    do {
      let data = try await apiService.request(request)
      if data.count == 0 {
        self.products = []
      } else {
        let productList = try JSONDecoder().decode(ProductList.self, from: data)
        self.products = productList.items ?? []
      }
    } catch {
      print(error)
      self.products = []
    }
  }
  
  func retrieveproductsMore(itemsPerPage: Int = 10) async {
    pageNumber += 1
    guard let request = ProductsListRequest(pageNumber: pageNumber,
                                            itemsPerPage: itemsPerPage,
                                            searchValue: searchValue).makeURLRequest() else {
      return
    }
    do {
      let data = try await apiService.request(request)
      let productList = try JSONDecoder().decode(ProductList.self, from: data)
      self.products.append(contentsOf: productList.items ?? [])
    } catch {
      print(error)
      self.products = []
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
  
  func deleteProduct() async {
    guard let productId = deleteReady else {
      return
    }
    guard let request = FetchDeleteURLRequest(productsId: productId, secret: UserInfomation.shared.secret).makeURLRequest() else {
      return
    }
    do {
      let deleteURLData = try await apiService.request(request)
      guard let deleteURL = String(data: deleteURLData, encoding: .utf8) else { return }
      guard let deleteRequest = DeleteProductRequest(deleteURL: deleteURL).makeURLRequest() else { return }
      
      let _ = try await apiService.request(deleteRequest)
      
    } catch {
      print("삭제 실패")
      print(error)
    }

  }
}

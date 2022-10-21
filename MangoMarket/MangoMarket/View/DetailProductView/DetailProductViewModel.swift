//
//  DetailProductViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/19.
//

import SwiftUI

class DetailProductViewModel: ObservableObject {
  @Published var selection: Int = 0
  @Published var productId: Int
  @Published var product: ProductDetail? = nil
  let apiService: APIService = APIService()
  
  var productName: String {
    return product?.name ?? "이름 없음"
  }
  
  var vendorName: String {
    return product?.vendor?.name ?? "미상"
  }
  
  var currency: String {
    return product?.currency?.rawValue ?? "??"
  }
  
  var stock: String {
    let stock = product?.stock ?? 0
    return "\(stock)"
  }
  
  var outOfStock: Bool {
    let stock = product?.stock ?? 0
    return stock == 0
  }
  
  var productPrice: String {
    guard let price = product?.price else {
      return "가격 정보 없음"
    }
    return formatPrice(price)
  }
  
  var bargainPrice: String {
    guard let price = product?.bargainPrice else {
      return "가격 정보 없음"
    }
    return formatPrice(price)
  }
  
  var salePercent: String {
    guard let price = product?.price else {
      return "0%"
    }
    guard let discountedPrice = product?.discountedPrice else {
      return "0%"
    }
    
    let salePercent = discountedPrice / price
    return "\(salePercent)"
  }
  
  var description: String {
    return product?.description ?? ""
  }
  
  var imageCount: Int {
    return product?.imageInfos?.count ?? 0
  }
  
  var images: [ProductImage] {
    return product?.imageInfos ?? []
  }
  
  var isMyProduct: Bool {
    let myUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
    return vendorName == myUserName
  }
  
  init(productId: Int) {
    self.selection = 0
    self.productId = productId
    self.product = nil
  }
  
  func deleteProduct() {
    guard let request = FetchDeleteURLRequest(productsId: productId, secret: "bjv33pu73cbajp1").makeURLRequest() else {
      return
    }
    
    apiService.request(request) { result in
      switch result {
        case .success(let success):
          guard let deleteURL = String(data: success, encoding: .utf8) else {
            return
          }
          print(deleteURL)
          guard let deleteRequest = DeleteProductRequest(deleteURL: deleteURL).makeURLRequest() else { return }
                  self.apiService.request(deleteRequest) { deleteResult in
                    switch deleteResult {
                      case .success(_):
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
  
  func fetchProduct() {
    guard let request = ProductDetailRequest(productsId: productId).makeURLRequest() else {
      return
    }
    apiService.request(request) { result in
      switch result {
        case .success(let success):
          do {
            let product = try JSONDecoder().decode(ProductDetail.self, from: success)
            DispatchQueue.main.async {
              self.product = product
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
  
  func fetchImage() -> [UIImage]{
    var images: [UIImage] = []
    product?.imageInfos?.forEach({ image in
      apiService.fetchImage(image.url ?? "") { result in
        switch result {
          case .success(let data):
            images.append(UIImage(data: data) ?? UIImage(systemName: "exclamationmark.icloud.fill")!)
          case .failure(_):
            images.append(UIImage(systemName: "exclamationmark.icloud")!)
        }
      }
    })
    return images
  }
  
  private func formatPrice(_ price: Double) -> String {
    let numberFormatter = NumberFormatter()
    var formattedPrice: String
    
    switch product?.currency {
      case.KRW:
        numberFormatter.numberStyle = .none
        formattedPrice = numberFormatter.string(from: price as NSNumber) ?? "가격 정보 없음"
      case.USD:
        numberFormatter.maximumFractionDigits = 2
        formattedPrice = numberFormatter.string(from: price as NSNumber) ?? "가격 정보 없음"
      case .none:
        formattedPrice = "가격 정보 없음"
    }
    
    return formattedPrice
  }
}

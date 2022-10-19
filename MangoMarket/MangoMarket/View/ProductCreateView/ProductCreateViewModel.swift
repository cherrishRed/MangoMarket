//
//  ProductCreateViewModel.swift
//  MangoMarket
//
//  Created by RED on 2022/10/19.
//

import SwiftUI

class ProductCreateViewModel: ObservableObject {
  @Published var title: String = ""
  @Published var description: String = ""
  @Published var price: String = ""
  @Published var discountedPrice: String = ""
  @Published var currency: Currency = .KRW
  @Published var images: [UIImage] = []
  
  @Published var showSheet = false
  @Published var showAlert = false
  @Published var alertmessage: ProductAlert = .postProductSuccess
  
  let mode: Mode
  let apiService: APIService = APIService()
  var maxImageCount: Int = 5
  var productId: Int?
  
  init(title: String = "",
       description: String = "",
       price: String = "",
       discountedPrice: String = "",
       currency: Currency = .KRW,
       images: [UIImage] = [],
       showSheet: Bool = false,
       showAlert: Bool = false,
       alertmessage: ProductCreateViewModel.ProductAlert = .postProductSuccess,
       maxImageCount: Int = 5) {
    self.title = title
    self.description = description
    self.price = price
    self.discountedPrice = discountedPrice
    self.currency = currency
    self.images = images
    self.showSheet = showSheet
    self.showAlert = showAlert
    self.alertmessage = alertmessage
    self.maxImageCount = maxImageCount
    self.mode = .create
    self.productId = nil
  }
  
  init(product: ProductDetail?, images: [UIImage]) {
    self.title = product?.name ?? ""
    self.description = product?.description ?? ""
    self.price = "\(product?.price ?? 0)"
    self.discountedPrice = "\(product?.discountedPrice ?? 0)"
    self.currency = product?.currency ?? .KRW
    self.images = images
    self.showSheet = false
    self.showAlert = false
    self.alertmessage = .editProductSuccess
    self.maxImageCount = 5
    self.mode = .edit
    self.productId = product?.id
  }
  
  var imageCount: Int {
    return images.count
  }
  
  var inactiveImagePicker: Bool {
    guard mode == .create else {
      return false
    }
    return images.count < maxImageCount 
  }
  
  var vaildTitle: Bool {
    return title.count > 2 && title.count < 101
  }
  
  var vaildDescription: Bool {
    return description.count > 9 && description.count < 1001
  }
  
  var vaildImageCount: Bool {
    return imageCount != 0 && imageCount < maxImageCount
  }
  
  var vaildPrice: Bool {
    let convertedPrice = Double(price)
    return price.isEmpty == false && convertedPrice != nil
  }
  
  var vaildDiscountedPrice: Bool {
    if discountedPrice == "" {
      return true
    }
    
    guard let convertedDiscountedPrice = Double(discountedPrice) else {
      return false
    }
    let convertedPrice = Double(price) ?? 0.0
    
    return convertedDiscountedPrice < convertedPrice
  }
  
  var vaildAll: Bool {
    return vaildTitle && vaildDescription && vaildImageCount && vaildPrice && vaildDiscountedPrice
  }
  
  func tappedImagePickerButton() {
    showSheet = true
  }
  
  func tappedCancelImageButton(index: Int) {
    images.remove(at: index)
  }
  
  func tappedPostButton() {
    if mode == .create {
      postProduct()
      DispatchQueue.main.async { [weak self] in
        self?.showAlert = true
      }
    } else {
      editProduct()
    }
  }
  
  private func postProduct() {
    guard let newProduct = makeProductRequest() else {
      return
    }

    print("newProduct")
    print(newProduct)
    apiService.postProducts(newProduct: newProduct)
  }
  
  private func editProduct() {
    guard let editedProduct = makeProductEditRequest() else {
      return
    }
    apiService.editProduct(id: productId ?? 0, product: editedProduct) { resutl in
      switch resutl {
        case .success(_):
          DispatchQueue.main.async { [weak self] in
            self?.alertmessage = .editProductSuccess
            self?.showAlert = true
          }
        case .failure(_):
          
          DispatchQueue.main.async { [weak self] in
            self?.alertmessage = .editProductFail
            self?.showAlert = true
          }
      }
    }
  }
  
  private func makeProductRequest() -> ProductRequest? {
    guard let priceDouble = Double(price) else {
      return nil
    }

    guard let disCountedPriceDouble = Double(discountedPrice) else {
      return nil
    }

    let imageInfos = images.map { (image) -> ImageInfo in
      guard let data = image.jpegData(compressionQuality: 0.1) else {
        return ImageInfo(fileName: "", data: Data(), type: "")
      }
      return ImageInfo(fileName: "\(Date())", data: data, type: "")
    }

    return ProductRequest(name: title, descriptions: description, price: priceDouble, currency: .KRW, discountedPrice: disCountedPriceDouble, stock: 10, secret: "bjv33pu73cbajp1", imageInfos: imageInfos)
  }
  
  private func makeProductEditRequest() -> ProductEditRequestModel? {
    guard let priceDouble = Double(price) else {
      return nil
    }

    guard let disCountedPriceDouble = Double(discountedPrice) else {
      return nil
    }

    return ProductEditRequestModel(name: title, descriptions: description, price: priceDouble, currency: .KRW, discountedPrice: disCountedPriceDouble, stock: 10, secret: "bjv33pu73cbajp1")
  }
  
  enum Mode {
    case edit
    case create
  }
  
  enum ProductAlert: Equatable {
    case postProductFail
    case postProductSuccess
    case editProductFail
    case editProductSuccess
    
    var message: String {
      switch self {
        case .postProductFail:
          return "상품 등록에 실패했습니다 🥲"
        case .postProductSuccess:
          return "상품이 성공적으로 등록됐습니다 🥰"
        case .editProductFail:
          return "상품 수정에 실패했습니다 🥲"
        case .editProductSuccess:
          return "상품이 성공적으로 수정됐습니다 🥰"
      }
    }
  }
}

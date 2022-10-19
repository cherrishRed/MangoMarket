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
  @Published var clickedPostButton = false
  @Published var alertmessage: ProductAlert = .invaildCondition
  
  let apiService: APIService = APIService()
  var maxImageCount: Int = 5
  
  var imageCount: Int {
    return images.count
  }
  
  var inactiveImagePicker: Bool {
    return images.count < maxImageCount 
  }
  
  var vaildTitle: Bool {
    return title.isEmpty == false && title.count < 101
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
    if vaildAll == false {
      ShowinvaildConditionAlert()
    } else {
      postProduct()
    }
  }
  
  private func ShowinvaildConditionAlert() {
    DispatchQueue.main.async { [weak self] in
      self?.clickedPostButton = true
      self?.alertmessage = .invaildCondition
      self?.showAlert = true
    }
  }
  
  private func postProduct() {
    guard let priceDouble = Double(price) else {
      return
    }

    guard let disCountedPriceDouble = Double(discountedPrice) else {
      return
    }

    let imageInfos = images.map { (image) -> ImageInfo in
      guard let data = image.jpegData(compressionQuality: 0.1) else {
        return ImageInfo(fileName: "", data: Data(), type: "")
      }
      return ImageInfo(fileName: "\(Date())", data: data, type: "")
    }

    let newProduct = ProductRequest(name: title, descriptions: description, price: priceDouble, currency: .KRW, discountedPrice: disCountedPriceDouble, stock: 10, secret: "bjv33pu73cbajp1", imageInfos: imageInfos)

    print("newProduct")
    print(newProduct)
    apiService.postProducts(newProduct: newProduct)
  }
  
  enum ProductAlert: Equatable {
    case invaildCondition
    case postProductFail
    case postProductSuccess
    case editProductFail
    case editProductSuccess
    
    var message: String {
      switch self {
        case .invaildCondition:
          return "조건에 맞지 않아요! \n 다시 한번 조건을 확인해 보세요 😚"
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

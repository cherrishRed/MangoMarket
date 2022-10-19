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
  let apiService: APIService = APIService()
  
  func tappedImagePickerButton() {
    showSheet = true
  }
  
  func tappedPostButton() {
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
}

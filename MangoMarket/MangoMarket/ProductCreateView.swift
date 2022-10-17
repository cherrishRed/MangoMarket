//
//  ProductCreateView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import SwiftUI

struct ProductCreateView: View {
  @State var title: String = ""
  @State var description: String = ""
  @State var price: String = ""
  @State var discountedPrice: String = ""
  @State var currency: Currency = .KRW
  
  @State private var images = [UIImage()]
  @State private var showSheet = false
  let apiService: APIService = APIService()
  
  var body: some View {
    Form {
      Section {
        ScrollView(.horizontal) {
          HStack {
            ForEach(images, id: \.self) { image in
              Image(uiImage: image)
                .resizable()
                .frame(width: 100, height: 100)
            }
            Button {
              showSheet = true
            } label: {
              Text("add image")
            }
          }
        }
      }
      
      Section {
        TextField("제품 이름", text: $title)
        HStack {
          TextField("가격", text: $price)
          Picker("", selection: $currency) {
            ForEach(Currency.allCases, id:\.self) { curreny in
              Text(curreny.rawValue)
            }
          }.pickerStyle(.segmented)
        }
        TextField("할인된 가격", text: $discountedPrice)
        TextField("제품 설명", text: $description)
      }
      
      Section {
        Button {
          guard let priceDouble = Double(price) else {
            return
          }
          
          guard let disCountedPriceDouble = Double(discountedPrice) else {
            return
          }
          
          let imageInfos = images.map { (image) -> ImageInfo in
            guard let data = image.jpegData(compressionQuality: 0) else {
              return ImageInfo(fileName: "", data: Data(), type: "")
            }
            return ImageInfo(fileName: "", data: data, type: "")
          }
          
          let newProduct = ProductRequest(name: title, descriptions: description, price: priceDouble, currency: .KRW, discountedPrice: disCountedPriceDouble, stock: 10, secret: "bjv33pu73cbajp1", imageInfos: imageInfos)
          
          apiService.postProducts(newProduct: newProduct)
          
//           제출
        } label: {
          Text("post 하기")
        }
      }
    }
    .sheet(isPresented: $showSheet) {
        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$images)
    }
  }
}

struct ProductCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCreateView()
    }
}

//
//  DetailProductView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/02.
//

import SwiftUI

struct DetailProductView: View {
  @State var selection: Int = 0
  @State var productId: Int
  @State var product: ProductDetail? = nil

  var body: some View {
    VStack(alignment: .leading) {
      
      if product?.imageInfos != nil {
        HStack {
          ForEach(product!.imageInfos!, id: \.self) { image in
            //let url = product.imageInfos[index] ?? URL()
            AsyncImage(url: URL(string: image.url ?? "")) { image in
              image
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            } placeholder: {
              ProgressView()
            }

            
          }
        }
      } else {
        Text("nil")
      }
      
      VStack(alignment: .leading) {
        Text(product?.name ?? "이름 없음")
          .font(.title)
          .fontWeight(.medium)
        HStack {
          Text("10%")
            .font(.title3)
            .foregroundColor(.red)
          Text(product?.currency?.rawValue ?? "환률 오류")
            .font(.title3)
          Text("900")
            .font(.title3)
            .fontWeight(.medium)
          Text("1000")
            .strikethrough()
            .foregroundColor(.gray)
        }
        
        Text("남은 수량 : \(product?.stock ?? 0)개")
        Text("글들...")
      
      }
      .padding(20)
    }
    .onAppear {
      let api = APIService()
      api.retrieveProduct(id: productId) { result in
        switch result {
          case .success(let success):
            do {
              let product = try JSONDecoder().decode(ProductDetail.self, from: success)
              self.product = product
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
}


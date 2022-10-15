//
//  DetailProductView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/02.
//

import SwiftUI

struct DetailProductView: View {
  @State var selection: Int = 0
  var product: ProductDetail

  var body: some View {
    VStack(alignment: .leading) {
      
      VStack(alignment: .leading) {
        Text(product.name ?? "이름 없음")
          .font(.title)
          .fontWeight(.medium)
        HStack {
          Text("10%")
            .font(.title3)
            .foregroundColor(.red)
          Text(product.currency?.rawValue ?? "환률 오류")
            .font(.title3)
          Text("900")
            .font(.title3)
            .fontWeight(.medium)
          Text("1000")
            .strikethrough()
            .foregroundColor(.gray)
        }
        
        Text("남은 수량 : \(product.stock ?? 0)개")
        Text("글들...")
      
      }
      .padding(20)
    }
  }
}


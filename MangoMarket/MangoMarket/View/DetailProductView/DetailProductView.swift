//
//  DetailProductView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/02.
//

import SwiftUI

struct DetailProductView: View {
  @ObservedObject var viewModel: DetailProductViewModel

  var body: some View {
    VStack(alignment: .leading) {
      if viewModel.product?.imageInfos != nil {
        HStack {
          ForEach(viewModel.product!.imageInfos!, id: \.self) { image in
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
        Text(viewModel.productName)
          .font(.title)
          .fontWeight(.medium)
        HStack {
          Text(viewModel.salePercent)
            .font(.title3)
            .foregroundColor(.red)
          Text(viewModel.currency)
            .font(.title3)
          Text(viewModel.bargainPrice)
            .font(.title3)
            .fontWeight(.medium)
          Text(viewModel.productPrice)
            .strikethrough()
            .foregroundColor(.gray)
        }
        
        Text("남은 수량 : \(viewModel.stock)개")
        Text(viewModel.description)
      
      }
      .padding(20)
    }
    .onAppear {
      viewModel.fetchProduct()
    }
  }
}


//
//  ProductListCell.swift
//  MangoMarket
//
//  Created by RED on 2022/11/01.
//

import SwiftUI

struct ProductGridCellView: View {
  @StateObject var viewModel: ProductListCellViewModel
  @Binding var onlyImage: Bool
  
  init(onlyImage: Binding<Bool>, product: ProductDetail) {
    self._viewModel = StateObject(wrappedValue: ProductListCellViewModel(product: product))
    self._onlyImage = onlyImage
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      ZStack(alignment: .bottomTrailing) {
        ImageLoadView(url: viewModel.thumbnailURL)
        
        Image(systemName: "heart")
          .foregroundColor(.red)
          .padding(.bottom, 10)
          .padding(.trailing, 10)
      }
      
      if onlyImage == false {
        VStack(alignment: .leading) {
          Text(viewModel.productName)
            .font(.title3)
            .fontWeight(.medium)
          if viewModel.noSale == false {
            Text(viewModel.productPrice)
              .strikethrough()
              .foregroundColor(.gray)
          }
          
          if viewModel.noSale == true {
            Text(viewModel.productPrice)
          } else {
            HStack {
              Text(viewModel.salePercent)
                .foregroundColor(.red)
              Text(viewModel.productDiscountedPrice)
            }
          }
          if viewModel.outOfStock {
            Text("품절")
              .foregroundColor(Color(uiColor: UIColor.systemRed))
          } else {
            Text("잔여수량 : \(viewModel.productStock) 개")
          }
        }
        .padding(.leading, 8)
      }
    }
  }
}

struct ProductRowCellView: View {
  @StateObject var viewModel: ProductListCellViewModel
  var delete: (Int) -> Void
  
  init(product: ProductDetail, delete: @escaping (Int) -> Void) {
    self._viewModel = StateObject(wrappedValue: ProductListCellViewModel(product: product))
    self.delete = delete
  }
  
  
  var body: some View {
    HStack {
      ImageLoadView(url: viewModel.thumbnailURL)
        .frame(width: 100, height: 100)
      
      VStack(alignment: .leading) {
        Text(viewModel.productName)
          .font(.title3)
          .fontWeight(.medium)
        
        if viewModel.noSale == false {
          Text(viewModel.productPrice)
            .strikethrough()
            .foregroundColor(.gray)
          
          HStack {
            Text(viewModel.salePercent)
              .foregroundColor(.red)
            Text(viewModel.productDiscountedPrice)
          }
        } else {
          Text(viewModel.productPrice)
        }
        
        if viewModel.outOfStock {
          Text("품절")
            .foregroundColor(Color(uiColor: UIColor.systemRed))
        } else {
          Text("잔여수량 : \(viewModel.productStock) 개")
        }
      }
      .padding(.leading, 8)
      Spacer()
      VStack {
        NavigationLink {
          ProductCreateView(viewModel: ProductCreateViewModel(product: viewModel.product, images: []))
        } label: {
          Text("수정하기")
            .font(.caption)
            .padding(4)
            .background(Color("logoYellow"))
            .foregroundColor(.white)
            .cornerRadius(4)
        }
        
        Button {
          delete(viewModel.product.id ?? 1)
        } label: {
          Text("삭제하기")
            .font(.caption)
            .padding(4)
            .background(Color(uiColor: UIColor.systemRed))
            .foregroundColor(.white)
            .cornerRadius(4)
        } 
      }
    }
  }
}

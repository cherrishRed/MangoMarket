//
//  ProductListView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct ProductListView: View {
  @State var onlyImage: Bool = false
  @State var products: [ProductDetail] = []
  
  var columns: [GridItem] = [GridItem(.flexible(), spacing: 10, alignment: nil),
                                    GridItem(.flexible(), spacing: 10, alignment: nil)]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, alignment: .center, spacing: 10, pinnedViews: [.sectionHeaders]) {
        
        Section(header:
            ProductListHeaderView(onlyImage: $onlyImage)
            ) {
          ForEach(products, id:\.self) { product in
            ProductCellView(onlyImage: $onlyImage, product: product)
            }
          }
        }
      .padding()
      }
      .onAppear {
      let apiService = APIService()
        apiService.retrieveProduct { result in
          switch result {
            case .success(let success):
              do {
                let productList = try JSONDecoder().decode(ProductList.self, from: success)
                products = productList.items ?? []
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

struct ProductListHeaderView: View {
  @Binding var onlyImage: Bool
  
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button {
          onlyImage.toggle()
        } label: {
          if onlyImage == true {
            Image(systemName: "chevron.down.square")
              .foregroundColor(.black)
          } else {
            Image(systemName: "square")
              .foregroundColor(.black)
          }
        }
        Text("이미지만 보기")
        Spacer()
      }
    }
    .padding(.bottom, 4)
    .background(.white)
  }
}

struct ProductCellView: View {
  @Binding var onlyImage: Bool
  var product: ProductDetail
  
  var body: some View {
    VStack(alignment: .leading) {
      ZStack(alignment: .bottomTrailing) {
        AsyncImage(url: product.thumbnail, content: { image in
          image
            .resizable()
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
        }, placeholder: {
          ProgressView()
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
        })
        Image(systemName: "heart")
          .foregroundColor(.red)
          .padding(.bottom, 10)
          .padding(.trailing, 10)
      }
      
      if onlyImage == false {
        VStack(alignment: .leading) {
          Text(product.name ?? "이름없음")
            .font(.title3)
            .fontWeight(.medium)
          Text("\(product.price ?? 0)")
            .strikethrough()
            .foregroundColor(.gray)
          HStack {
            Text("20%")
              .foregroundColor(.red)
            Text("\(product.discountedPrice ?? 0)")
          }
          Text("잔여수량 : \(product.stock ?? 0) 개")
        }
        .padding(.leading, 8)
      }
  }
}

}

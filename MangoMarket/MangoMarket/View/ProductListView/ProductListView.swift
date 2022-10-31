//
//  ProductListView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct ProductListView: View {
  @ObservedObject var viewModel = ProductListViewModel()
  
  var columns: [GridItem] = [GridItem(.flexible(), spacing: 10, alignment: nil),
                             GridItem(.flexible(), spacing: 10, alignment: nil)]
  
  init(viewModel: ProductListViewModel = ProductListViewModel()) {
    self.viewModel = viewModel
    switch viewModel.layout {
      case .grid:
        self.columns = [GridItem(.flexible(), spacing: 10, alignment: nil),
                        GridItem(.flexible(), spacing: 10, alignment: nil)]
      case .row:
        self.columns = [GridItem(.flexible(), spacing: 10, alignment: nil)]
    }
  }
  
  var body: some View {
    ScrollView {
      if viewModel.productIsEmpty {
        Text("제품이 없습니다")
      } else {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10, pinnedViews: viewModel.layout == .grid ? [.sectionHeaders] : []) {
          switch viewModel.layout {
            case .grid:
              Section(header: ProductListHeaderView(onlyImage: $viewModel.onlyImage)) {
                ForEach(viewModel.products, id:\.self) { product in
                  NavigationLink {
                    DetailProductView(viewModel: DetailProductViewModel(productId: product.id ?? 1))
                  } label: {
                    ProductGridCellView(onlyImage: $viewModel.onlyImage, product: product)
                  }
                }
              }
            case .row:
              ForEach(viewModel.products, id:\.self) { product in
                NavigationLink {
                  DetailProductView(viewModel: DetailProductViewModel(productId: product.id ?? 1))
                } label: {
                  ProductRowCellView(product: product, delete: viewModel.tappedDeleteButton)
                }
              }
          }
        }
        .padding()
      }
    }
    .refreshable {
      viewModel.retrieveProducts()
    }
    .alert("정말로?", isPresented: $viewModel.showAlert, actions: {
      Button {
        viewModel.deleteProduct()
      } label: {
        Text("확인")
      }
      
      Button(role: .cancel) {
        // 취소
      } label: {
        Text("취소")
      }
    }, message: {
      Text("삭제 할껀가요?")
    })
    .onAppear {
      viewModel.retrieveProducts()
    }
    .onChange(of: viewModel.searchValue) { newValue in
      viewModel.retrieveProducts()
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

struct ProductGridCellView: View {
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
          if product.stock == 0 {
            Text("품절")
              .foregroundColor(Color(uiColor: UIColor.systemRed))
          } else {
            Text("잔여수량 : \(product.stock ?? 0) 개")
          }
        }
        .padding(.leading, 8)
      }
    }
  }
}

struct ProductRowCellView: View {
  var product: ProductDetail
  var delete: (Int) -> Void
  
  var salePercent: String {
    guard let price = product.price else {
      return "0%"
    }
    guard let discountedPrice = product.discountedPrice else {
      return "0%"
    }
    // NAN 오류가 나는 이유
    let salePercent = discountedPrice / price
    return "\(Float(round(salePercent*100)))%"
  }
  
  var body: some View {
    HStack {
      AsyncImage(url: product.thumbnail, content: { image in
        image
          .resizable()
          .frame(width: 100, height: 100)
          .aspectRatio(1, contentMode: .fit)
          .cornerRadius(10)
      }, placeholder: {
        ProgressView()
          .frame(maxWidth: .infinity)
          .aspectRatio(1, contentMode: .fit)
      })
      
      VStack(alignment: .leading) {
        Text(product.name ?? "이름없음")
          .font(.title3)
          .fontWeight(.medium)
        Text("\(product.price ?? 0)")
          .strikethrough()
          .foregroundColor(.gray)
        HStack {
          Text(salePercent)
            .foregroundColor(.red)
          Text("\(product.discountedPrice ?? 0)")
        }
        if product.stock == 0 {
          Text("품절")
            .foregroundColor(Color(uiColor: UIColor.systemRed))
        } else {
          Text("잔여수량 : \(product.stock ?? 0) 개")
        }
      }
      .padding(.leading, 8)
      Spacer()
      VStack {
        NavigationLink {
          ProductCreateView(viewModel: ProductCreateViewModel(product: product, images: []))
        } label: {
          Text("수정하기")
            .font(.caption)
            .padding(4)
            .background(Color("logoYellow"))
            .foregroundColor(.white)
            .cornerRadius(4)
        }
        
        Button {
          delete(product.id ?? 1)
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

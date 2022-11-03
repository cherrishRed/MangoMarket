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
                      .foregroundColor(.black)
                  }
                }
              }
            case .row:
              ForEach(viewModel.products, id:\.self) { product in
                NavigationLink {
                  DetailProductView(viewModel: DetailProductViewModel(productId: product.id ?? 1))
                } label: {
                  ProductRowCellView(product: product, delete: viewModel.tappedDeleteButton)
                    .foregroundColor(.black)
                }
              }
          }
        }
        .padding()
        Button {
          Task {
            await viewModel.retrieveproductsMore()
          }
        } label: {
          VStack(spacing: 10) {
            Text("더보기")
            Image(systemName: "chevron.down")
          }
          .foregroundColor(.black)
        }
      }
    }
    .refreshable {
      Task {
        await viewModel.retrieveProducts()
      }
    }
    .alert("정말로?", isPresented: $viewModel.showAlert, actions: {
      Button {
        Task {
          await viewModel.deleteProduct()
        }
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
      Task {
        await viewModel.retrieveProducts()
      }
    }
    .onChange(of: viewModel.searchValue) { newValue in
      Task {
        await viewModel.retrieveProducts()
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



//
//  DetailProductView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/02.
//

import SwiftUI

struct DetailProductView: View {
  @ObservedObject var viewModel: DetailProductViewModel
  @Environment(\.presentationMode) var presentation
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        if viewModel.product?.imageInfos != nil {
          VStack(alignment: .center, spacing: 10) {
            imagePagingView
            if viewModel.imageCount > 1 {
              imageIndicatior
            }
          }
        } else {
          Text("nil")
        }
        
        VStack(alignment: .leading) {
          Divider()
          if viewModel.isMyProduct {
            myProductView
          } else {
            vendorView
          }
          Divider()
          Text(viewModel.productName)
            .font(.title)
            .fontWeight(.medium)
          
          if viewModel.noSale {
            HStack {
              Text(viewModel.currency)
                .font(.title3)
              Text(viewModel.bargainPrice)
                .font(.title3)
                .fontWeight(.medium)
            }
          } else {
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
          }
          
          if viewModel.outOfStock {
            Text("품절")
              .foregroundColor(Color(uiColor: UIColor.systemRed))
          } else {
            Text("남은 수량 : \(viewModel.stock)개")
          }
          Divider()
          Text(viewModel.description)
          
        }
        .padding(20)
      }
    }
    .onAppear {
      Task {
        await viewModel.fetchProduct()
      }
    }
  }
  
  var imagePagingView: some View {
    TabView(selection: $viewModel.selection) {
      ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
        AsyncImage(url: URL(string: image.url ?? "")) { image in
          image
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
        } placeholder: {
          ProgressView()
        }.tag(index)
      }
    }
    .animation(.interactiveSpring(), value: viewModel.selection)
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
  }
  
  var imageIndicatior: some View {
    HStack {
      ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
        
        ZStack {
          Rectangle()
            .frame(width: 52, height: 52)
            .opacity(viewModel.selection == index ? 1 : 0)
          AsyncImage(url: URL(string: image.url ?? "")) { image in
            image
              .resizable()
              .frame(width: 50, height: 50, alignment: .center)
          } placeholder: {
            ProgressView()
          }
        }
        .animation(.interactiveSpring(), value: viewModel.selection)
        .onTapGesture {
          viewModel.selection = index
        }
      }
    }
  }
  
  var vendorView: some View {
    HStack {
      Image(systemName: "person.crop.circle")
        .foregroundColor(Color("logoYellow"))
      Text(viewModel.vendorName)
        .font(.caption)
    }
  }
  
  var myProductView: some View {
    HStack {
      Text("나의 상품")
        .font(.caption)
      Spacer()
      NavigationLink {
        ProductCreateView(viewModel: ProductCreateViewModel(product: viewModel.product, images: viewModel.uiImages))
      } label: {
        Text("수정하기")
          .font(.caption)
          .padding(4)
          .background(Color("logoYellow"))
          .foregroundColor(.white)
          .cornerRadius(4)
      }
      
      Button {
        viewModel.tappedDeleteButton()
      } label: {
        Text("삭제하기")
          .font(.caption)
          .padding(4)
          .background(Color(uiColor: UIColor.systemRed))
          .foregroundColor(.white)
          .cornerRadius(4)
      }
      
    }
    .onAppear {
      Task {
        guard let imageInfos = viewModel.product?.imageInfos else { return }
        await viewModel.fetchImage(imagesInfo: imageInfos)
      }
    }
    .alert("정말로?", isPresented: $viewModel.showAlert, actions: {
      Button {
        Task {
          await viewModel.deleteProduct()
        }
        self.presentation.wrappedValue.dismiss()
      } label: {
        Text("확인")
      }
      
      Button(role: .cancel) {
      } label: {
        Text("취소")
      }
    }, message: {
      Text("삭제 할껀가요?")
    })
  }
}


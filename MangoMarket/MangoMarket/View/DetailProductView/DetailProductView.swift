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
          HStack {
            Image(systemName: "person.crop.circle")
              .foregroundColor(.yellow)
            Text(viewModel.vendorName)
              .font(.caption)
          }
          Divider()
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
          Divider()
          Text(viewModel.description)
        
        }
        .padding(20)
      }
    }
    .onAppear {
      viewModel.fetchProduct()
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
}


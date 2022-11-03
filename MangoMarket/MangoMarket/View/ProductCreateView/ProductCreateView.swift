//
//  ProductCreateView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import SwiftUI

struct ProductCreateView: View {
  @ObservedObject var viewModel = ProductCreateViewModel()
  @Environment(\.presentationMode) var presentation
  
  enum Constant: String {
    case productAdd
    case productEdit
    case ok
    case productNamePlaceHolder
    case productStockPlaceHolder
    case productPricePlaceHolder
    case productDiscountedPricePlaceHolder
    case productDescriptionPlaceHolder
    case productImageAlert
    
    var message: String {
      switch self {
        case .productAdd:
          return "상품 등록 하기"
        case .productEdit:
          return "상품 수정 하기"
        case .ok:
          return "확인"
        case .productNamePlaceHolder:
          return "상품 이름 3 ~ 100 글자"
        case .productStockPlaceHolder:
          return "상품 수량"
        case .productPricePlaceHolder:
          return "가격"
        case .productDiscountedPricePlaceHolder:
          return "할인할 가격(상품가격 보다 높게 측정 금지)"
        case .productDescriptionPlaceHolder:
          return "제품 설명 10 ~ 1,000 글자"
        case .productImageAlert:
          return "이미지는 최소 1장 첨부 해주세요 \n이미지는 추후에 수정할 수 없습니다"
      }
    }
  }
  
  var body: some View {
    Form(content: {
      Section {
        imageView
        if viewModel.mode == .create {
          validateImageView
        }
      }
      .animation(.easeInOut, value: viewModel.images)
      
      Section {
        productImageView
        productPriceView
        productDiscountedPriceView
        productStockView
        productDescriptionView
      }
      
      if viewModel.vaildAll {
        Section {
          Button {
            Task {
              await viewModel.tappedPostButton()
              self.presentation.wrappedValue.dismiss()
            }
          } label: {
            switch viewModel.mode {
              case.create:
                Text(Constant.productAdd.message)
              case.edit:
                Text(Constant.productEdit.message)
            }
          }
        }
      }
    })
    .sheet(isPresented: $viewModel.showSheet) {
      ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.images)
    }
    .alert("\(viewModel.alertmessage.message)", isPresented: $viewModel.showAlert) {
      Button(role: .none) {
      } label: {
        Text(Constant.ok.message)
      }
    }
  }
  
  var imagePickerView: some View {
    ZStack{
      Rectangle()
        .fill(Color(uiColor: UIColor.systemGray6))
        .frame(width: 100, height: 100, alignment: .center)
        .cornerRadius(10)
      VStack {
        Image(systemName: "photo.on.rectangle")
          .padding(6)
          .foregroundColor(Color(uiColor: UIColor.gray))
        Text("\(viewModel.imageCount)/\(viewModel.maxImageCount)")
          .foregroundColor(Color(uiColor: UIColor.gray))
      }
    }
  }
  
  var imageView: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(Array(viewModel.images.enumerated()), id: \.offset) { (index, image) in
          ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
              .resizable()
              .frame(width: 100, height: 100)
              .cornerRadius(10)
            if viewModel.mode == .create {
              Button {
                viewModel.tappedCancelImageButton(index: index)
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.red)
              }
            }
          }
        }
        if viewModel.inactiveImagePicker == true {
          Button {
            viewModel.tappedImagePickerButton()
          } label: {
            imagePickerView
          }
        }
      }
    }
  }
  
  var productImageView: some View {
    ZStack(alignment: .trailing) {
      TextField(Constant.productNamePlaceHolder.message, text: $viewModel.title)
      Image(systemName: viewModel.vaildTitle ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildTitle ? .green : .red)
    }
  }
  
  var productStockView: some View {
    ZStack(alignment: .trailing) {
      TextField(Constant.productStockPlaceHolder.message, text: $viewModel.stock)
      Image(systemName: viewModel.vaildTitle ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildStock ? .green : .red)
    }
  }
  
  var productPriceView: some View {
    HStack {
      ZStack(alignment: .trailing) {
        TextField(Constant.productPricePlaceHolder.message, text: $viewModel.price)
        Image(systemName: viewModel.vaildPrice ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildPrice ? .green : .red)
        
      }
      Picker("", selection: $viewModel.currency) {
        ForEach(Currency.allCases, id:\.self) { curreny in
          Text(curreny.rawValue)
        }
      }.pickerStyle(.segmented)
        .frame(width: 100)
    }
  }
  
  var productDiscountedPriceView: some View {
    ZStack(alignment: .trailing) {
      TextField(Constant.productDiscountedPricePlaceHolder.message, text: $viewModel.discountedPrice)
      Image(systemName: viewModel.vaildDiscountedPrice ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildDiscountedPrice ? .green : .red)
    }
  }
  
  var productDescriptionView: some View {
    ZStack(alignment: .trailing) {
      TextField(Constant.productDescriptionPlaceHolder.message, text: $viewModel.description)
      Image(systemName: viewModel.vaildDescription ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildDescription ? .green : .red)
    }
  }
  
  var validateImageView: some View {
    HStack {
      Text(Constant.productImageAlert.message)
        .font(.caption)
        .foregroundColor(.gray)
      Spacer()
      Image(systemName: viewModel.vaildImageCount ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildImageCount ? .green : .red)
    }
  }
}

//
//  ProductCreateView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import SwiftUI

struct ProductCreateView: View {
  @ObservedObject var viewModel = ProductCreateViewModel()
  
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
        productDescriptionView
      }
      
      if viewModel.vaildAll {
        Section {
          Button {
            viewModel.tappedPostButton()
          } label: {
            switch viewModel.mode {
              case.create:
                Text("상품 등록 하기")
              case.edit:
                Text("상품 수정 하기")
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
        //
      } label: {
        Text("확인")
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
      TextField("상품 이름 3 ~ 100 글자", text: $viewModel.title)
      Image(systemName: viewModel.vaildTitle ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildTitle ? .green : .red)
    }
  }
  
  var productPriceView: some View {
    HStack {
      ZStack(alignment: .trailing) {
        TextField("가격", text: $viewModel.price)
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
      TextField("할인할 가격(상품가격 보다 높게 측정 금지)", text: $viewModel.discountedPrice)
      Image(systemName: viewModel.vaildDiscountedPrice ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildDiscountedPrice ? .green : .red)
    }
  }
  
  var productDescriptionView: some View {
    ZStack(alignment: .trailing) {
      TextField("제품 설명 10 ~ 1,000 글자", text: $viewModel.description)
      Image(systemName: viewModel.vaildDescription ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildDescription ? .green : .red)
    }
  }
  
  var validateImageView: some View {
    HStack {
      Text("이미지는 최소 1장 첨부 해주세요 \n이미지는 추후에 수정할 수 없습니다")
        .font(.caption)
        .foregroundColor(.gray)
      Spacer()
      Image(systemName: viewModel.vaildImageCount ? "checkmark" : "xmark")
        .foregroundColor(viewModel.vaildImageCount ? .green : .red)
    }
  }
}

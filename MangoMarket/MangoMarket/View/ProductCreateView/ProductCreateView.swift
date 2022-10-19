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
          ScrollView(.horizontal) {
            HStack {
              ForEach(Array(viewModel.images.enumerated()), id: \.offset) { (index, image) in
                ZStack(alignment: .topTrailing) {
                  Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                  Button {
                    viewModel.tappedCancelImageButton(index: index)
                  } label: {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.red)
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
        .animation(.easeInOut, value: viewModel.images)
        
        Section {
          TextField("제품 이름", text: $viewModel.title)
          HStack {
            TextField("가격", text: $viewModel.price)
            Picker("", selection: $viewModel.currency) {
              ForEach(Currency.allCases, id:\.self) { curreny in
                Text(curreny.rawValue)
              }
            }.pickerStyle(.segmented)
          }
          TextField("할인된 가격", text: $viewModel.discountedPrice)
          TextField("제품 설명", text: $viewModel.description)
        }
      
      if viewModel.clickedPostButton {
        validCheckView
      }
      
        Section {
          Button {
            viewModel.tappedPostButton()
          } label: {
            Text("post 하기")
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
  
  var validCheckView: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("상품 이름 3 ~ 100 글자")
        Spacer()
        Image(systemName: viewModel.vaildTitle ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildTitle ? .green : .red)
      }
      HStack {
        Text("이미지는 최소 1장 최대 \(viewModel.maxImageCount) 첨부")
        Spacer()
        Image(systemName: viewModel.vaildImageCount ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildImageCount ? .green : .red)
      }
      HStack {
        Text("상품 가격 입력")
        Spacer()
        Image(systemName: viewModel.vaildPrice ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildPrice ? .green : .red)
      }
      HStack {
        Text("할인가는 가격을 초과 금지")
        Spacer()
        Image(systemName: viewModel.vaildDiscountedPrice ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildDiscountedPrice ? .green : .red)
      }
      HStack {
        Text("상품 정보 10 ~ 1,000 글자")
        Spacer()
        Image(systemName: viewModel.vaildDescription ? "checkmark" : "xmark")
          .foregroundColor(viewModel.vaildDescription ? .green : .red)
      }
    }
  }
}

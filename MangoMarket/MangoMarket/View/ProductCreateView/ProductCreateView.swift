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
              ForEach(viewModel.images, id: \.self) { image in
                Image(uiImage: image)
                  .resizable()
                  .frame(width: 100, height: 100)
              }
              Button {
                viewModel.tappedImagePickerButton()
              } label: {
                ZStack{
                  Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(10)
                  Image(systemName: "photo.on.rectangle")
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.white)
                }
              }
            }
          }
        }
        
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
  }
}

struct ProductCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCreateView()
    }
}

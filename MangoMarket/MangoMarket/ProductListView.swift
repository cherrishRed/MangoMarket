//
//  ProductListView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct ProductListView: View {
  @State var onlyImage: Bool = false
  var columns: [GridItem] = [GridItem(.flexible(), spacing: 10, alignment: nil),
                                    GridItem(.flexible(), spacing: 10, alignment: nil)]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, alignment: .center, spacing: 10, pinnedViews: [.sectionHeaders]) {
        
        Section(header:
            ProductListHeaderView(onlyImage: $onlyImage)
            ) {
          ForEach(1..<100) { number in
            ProductCellView(onlyImage: $onlyImage, product: number)
            }
          }
        }
      .padding()
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
  var product: Int
  
  var body: some View {
    VStack(alignment: .leading) {
      ZStack(alignment: .bottomTrailing) {
        Rectangle()
          .scale(x: 1, y: 1, anchor: .center)
          .fill(.gray)
          .frame(maxWidth: .infinity)
          .aspectRatio(1, contentMode: .fill)
        .cornerRadius(10)
        Image(systemName: "heart")
          .foregroundColor(.red)
          .padding(.bottom, 10)
          .padding(.trailing, 10)
      }
      
      if onlyImage == false {
        VStack(alignment: .leading) {
          Text("\(product) 번 제품")
            .font(.title3)
            .fontWeight(.medium)
          Text("12000")
            .strikethrough()
            .foregroundColor(.gray)
          HStack {
            Text("20%")
              .foregroundColor(.red)
            Text("9600")
          }
          Text("잔여수량 : 38 개")
        }
        .padding(.leading, 8)
      }
  }
}

}

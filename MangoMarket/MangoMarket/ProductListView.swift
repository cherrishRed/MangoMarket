//
//  ProductListView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct ProductListView: View {
  var columns: [GridItem] = [GridItem(.flexible(), spacing: 10, alignment: nil),
                                    GridItem(.flexible(), spacing: 10, alignment: nil)]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, alignment: .center, spacing: 10, pinnedViews: []) {
        
        Section(header:
            ProductListHeaderView()
            ) {
          ForEach(1..<100) { number in
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
              
              VStack(alignment: .leading) {
                Text("\(number) 번 제품")
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
      .padding()
    }
  }
}

struct ProductListHeaderView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button {
          
        } label: {
          Image(systemName: "square")
        }
        Text("이미지만 보기")
        Spacer()
      }
    }
  }
}

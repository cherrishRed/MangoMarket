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
      ForEach(1..<100) { number in
        Rectangle()
          .scale(x: 1, y: 1, anchor: .center)
          .fill(.gray)
          .frame(maxWidth: .infinity)
          .aspectRatio(1, contentMode: .fill)
          .cornerRadius(10)
      }
    }
    .padding()
    }
  }
}

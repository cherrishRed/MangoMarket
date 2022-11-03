//
//  BannerView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct BannerView: View {
  @State var selection: Int = 0
  
  var body: some View {
    TabView(selection: $selection) {
      Image("timeAttack")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .tag(0)
      Image("fruitSale")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .tag(1)
      Image("userSale")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .tag(2)
    }
    .animation(.easeInOut, value: selection)
    .frame(maxWidth: .infinity, maxHeight: 200)
    .tabViewStyle(.page)
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
        if selection == 2 {
          selection = 0
        } else {
          selection += 1
        }
      }
    }
  }
}

//
//  MainView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI

struct MainView: View {
    var body: some View {
      VStack {
        HeaderView()
        BannerView()
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct HeaderView: View {
  var body: some View {
    HStack(spacing: 0) {
      Text("Mango Market")
        .fontWeight(.heavy)
        .padding(.leading,40)
        .frame(maxWidth: .infinity)
      Button {
        
      } label: {
        Image(systemName: "magnifyingglass")
          .frame(width: 30, height:30, alignment: .center)
          .foregroundColor(.black)
      }
    }
    .padding()
  }
}

struct BannerView: View {
  @State var banners: [Color] = [.red, .yellow, .purple]
  
  var body: some View {
    TabView{
      ForEach(banners, id:\.self) { color in
        Rectangle()
          .fill(color)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: 200)
    .tabViewStyle(.page)
  }
}

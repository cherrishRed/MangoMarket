//
//  HomeView.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import SwiftUI
import Combine

struct HomeView: View {
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        VStack {
          HeaderView()
          //            BannerView()
          ProductListView()
        }
        NavigationLink {
          ProductCreateView()
        } label: {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30,height: 30)
            .foregroundColor(Color.logoYellow)
            .padding()
        }
      }
    }
  }
}

struct HeaderView: View {
  var body: some View {
    HStack(spacing: 0) {
      Text("Mango Market")
        .fontWeight(.heavy)
        .padding(.leading,40)
        .frame(maxWidth: .infinity)
      NavigationLink {
        SearchView()
      } label: {
        Image(systemName: "magnifyingglass")
          .frame(width: 30, height:30, alignment: .center)
          .foregroundColor(.black)
      }
    }
    .padding()
  }
}

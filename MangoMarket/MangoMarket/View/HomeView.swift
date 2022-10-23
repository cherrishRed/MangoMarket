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
              .foregroundColor(Color("logoYellow"))
              .padding()
          }
        }
      }
      .onAppear {
        UserDefaults.standard.set("red123", forKey: "userName")
        UserDefaults.standard.set("81da9d11-4b9d-11ed-a200-81a344d1e7cb", forKey: "identifier")
        UserDefaults.standard.set("bjv33pu73cbajp1", forKey: "secret")
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

//
//  MainView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/23.
//

import SwiftUI

struct MainView: View {
  @State var seletedtab: String = TabItem.home.rawValue
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        tabView
        tabItemView
      }
    }
  }
  
  var tabView: some View {
    TabView(selection: $seletedtab) {
      HomeView()
        .ignoresSafeArea()
        .tag("home")
      ProfileView()
        .tag("profile")
    }
  }
  
  var tabItemView: some View {
    ZStack(alignment: .bottomTrailing) {
      Rectangle()
        .fill(.white)
        .ignoresSafeArea()
        .frame(height: 50)
      
      NavigationLink {
        ProductCreateView()
      } label: {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(width: 30, height: 30)
          .padding(.trailing, 30)
      }
      
      VStack(alignment: .leading) {
        HStack(spacing: 30) {
          ForEach(TabItem.allCases, id: \.self) { tab in
            Button {
              withAnimation(.spring()) {
                seletedtab = tab.rawValue
              }
            } label: {
              Image(systemName: seletedtab == tab.rawValue ? tab.seletedIcon : tab.icon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(seletedtab == tab.rawValue ? Color.blue : Color.gray)
                .padding(.top, 30)
            }
          }
          Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
      }
    }
  }
}

enum TabItem: String, CaseIterable, Hashable {
  case home
  case profile
  
  var icon: String {
    switch self {
      case .home:
        return "house"
      case .profile:
        return "person"
    }
  }
  
  var seletedIcon: String {
    switch self {
      case .home:
        return "house.fill"
      case .profile:
        return "person.fill"
    }
  }
}

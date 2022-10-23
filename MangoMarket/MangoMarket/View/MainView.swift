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
      Color(uiColor: UIColor.yellow)
        .ignoresSafeArea()
        .tag("like")
      ProfileView()
//        .ignoresSafeArea()
        .tag("profile")
    }
  }
  
  var tabItemView: some View {
    ZStack(alignment: .bottomTrailing) {
      Rectangle()
        .fill(.white)
        .ignoresSafeArea()
        .frame(height: 50)
      
      Circle()
        .fill(.white)
        .frame(width: 60, height: 60)
        .padding(.trailing, 20)
      
      NavigationLink {
        ProductCreateView()
      } label: {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(width: 40, height: 40)
          .padding(.trailing, 28)
          .padding(.bottom, 10)
      }
      
      HStack {
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
          Spacer()
        }
      }
      .padding(.horizontal, 30)
    .padding(.top, 10)
    }
  }
}

enum TabItem: String, CaseIterable, Hashable {
  case home
  case like
  case profile
  
  var icon: String {
    switch self {
      case .home:
        return "house"
      case .like:
        return "heart"
      case .profile:
        return "person"
    }
  }
  
  var seletedIcon: String {
    switch self {
      case .home:
        return "house.fill"
      case .like:
        return "heart.fill"
      case .profile:
        return "person.fill"
    }
  }
}

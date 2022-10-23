//
//  Home.swift
//  MangoMarket
//
//  Created by RED on 2022/10/23.
//

import SwiftUI

struct Home: View {
  @State var seletedtab: String = TabItem.home.rawValue
  
  init() {
    UITabBar.appearance().isHidden = true
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      TabView(selection: $seletedtab) {
        Color(uiColor: UIColor.red)
          .ignoresSafeArea()
          .tag("home")
        Color(uiColor: UIColor.yellow)
          .ignoresSafeArea()
          .tag("like")
        Color(uiColor: UIColor.orange)
          .ignoresSafeArea()
          .tag("profile")
      }
      
      ZStack(alignment: .bottomTrailing) {
        Rectangle()
          .fill(.white)
          .ignoresSafeArea()
          .frame(height: 50)
        
        
        Circle()
          .fill(.white)
          .frame(width: 60, height: 60)
          .padding()
        
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
          Button {
            //
          } label: {
            ZStack {
//              Circle()
//                .fill(.white)
//                .frame(width: 60, height: 60)
              Image(systemName: "plus.circle.fill")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            }
          }

        }
        .padding(.horizontal, 30)
      .padding(.top, 10)
      }
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
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

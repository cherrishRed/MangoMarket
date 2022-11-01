//
//  ProfileView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import SwiftUI

struct ProfileView: View {
  @State var darkMode: Bool = false
  let productListViewModel = ProductListViewModel(searchValue: UserInfomation.shared.userName, layout: .row)
  
    var body: some View {
      VStack(alignment: .leading) {
        userProfileView
        Text("내가 등록한 제품")
          .padding(.horizontal, 20)
          .padding(.top, 10)
          .font(.title3)
        ProductListView(viewModel: productListViewModel)
      }
      .padding(.top, 20)
      .onAppear {
      }
    }
  
  var userProfileView: some View {
    HStack(spacing: 20) {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 60, height: 60)
      VStack(alignment: .leading) {
        Text(UserDefaults.standard.string(forKey: "userName") ?? "No Name")
          .font(.title2)
          .fontWeight(.semibold)
      }
    }
    .padding(.horizontal, 30)
  }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

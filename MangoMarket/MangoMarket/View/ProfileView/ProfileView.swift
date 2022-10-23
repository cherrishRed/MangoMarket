//
//  ProfileView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import SwiftUI

struct ProfileView: View {
  @State var darkMode: Bool = false
  
    var body: some View {
      VStack(alignment: .leading) {
        userProfileView
        Form {
          HStack {
            Text("다크 모드")
            Toggle("", isOn: $darkMode)
          }
        }
      }
      .padding(.top, 20)
    }
  
  var userProfileView: some View {
    HStack(spacing: 20) {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 80, height: 80)
      VStack(alignment: .leading) {
        Text(UserDefaults.standard.string(forKey: "userName") ?? "No Name")
          .font(.title2)
          .fontWeight(.semibold)
      }
    }
    .padding(.horizontal, 30)
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

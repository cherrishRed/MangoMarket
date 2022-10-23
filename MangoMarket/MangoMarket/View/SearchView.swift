//
//  SearchView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import SwiftUI

struct SearchView: View {
  @State private var searchText = ""
  var keywords: [String] = ["곰돌이", "코딩", "고양이", "강아지"]

  let columns = [
    GridItem(.flexible(), spacing: 0, alignment: nil),
    GridItem(.flexible(), spacing: 0, alignment: nil),
    GridItem(.flexible(), spacing: 0, alignment: nil)
  ]
  
    var body: some View {
      VStack(alignment: .center,spacing: 20) {
        SearchBar()
        ScrollView {
          recommendedKeyword
        }
      }
    }
  
  var recommendedKeyword: some View {
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(keywords, id: \.self) { keyword in
          Button(keyword) {
            searchText = keyword
          }
          .buttonStyle(KeywordButtonStyle())
        }
      }
    }
    .padding(.horizontal)
  }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchBar: View {
  @State private var searchText = ""
    var body: some View {
      HStack {
        Button {
          // dismiss
        } label: {
          Image(systemName: "chevron.backward")
            .foregroundColor(.black)
        }
        HStack {
          TextField("검색하기", text: $searchText)
          Button {
            searchText = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
              .opacity(searchText == "" ? 0.0 : 1.0)
          }
        }
        .foregroundColor(.primary)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
      }
      .padding(.horizontal)
    }
}

struct KeywordButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding(.horizontal)
      .padding(.vertical, 4)
      .foregroundColor(configuration.isPressed ? .white : .gray)
      .background {
        if configuration.isPressed == true {
          RoundedRectangle(cornerRadius: 20)
            .fill(.gray)
        }
        RoundedRectangle(cornerRadius: 20)
          .strokeBorder(.gray)
      }
  }
}

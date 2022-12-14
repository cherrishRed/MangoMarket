//
//  SearchView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/24.
//

import SwiftUI

struct SearchView: View {
  @ObservedObject var viewModel = SearchViewModel()
  let productListViewModel = ProductListViewModel()
  
  let columns = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: nil), count: 3)
  
  var body: some View {
    VStack(spacing: 20) {
      SearchBar(searchText: $viewModel.searchText)
      ScrollView {
        if viewModel.searchTextIsEmpty {
          recommendedKeyword
        } else {
          ProductListView(viewModel: productListViewModel)
        }
      }
    }
    .onChange(of: viewModel.searchText) { updatedSearchText in
      productListViewModel.changeSearchValue(viewModel.searchText)
    }
  }
  
  var recommendedKeyword: some View {
    VStack {
      LazyVGrid(columns: columns) {
        ForEach(viewModel.keywords, id: \.self) { keyword in
          Button(keyword) {
            viewModel.tappedKeywordButton(keyword)
          }
          .buttonStyle(KeywordButtonStyle())
        }
      }
    }
    .padding(.horizontal)
  }
}

struct SearchBar: View {
  @Binding var searchText: String
  
  init(searchText: Binding<String>) {
    self._searchText = searchText
  }
  var body: some View {
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
    .padding(.horizontal)
  }
}

//
//  ImageLoadView.swift
//  MangoMarket
//
//  Created by RED on 2022/11/01.
//

import SwiftUI

struct ImageLoadView: View {
  @StateObject var imageLoader: ImageLoader
  
  init(url: String?) {
    self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
  }
    var body: some View {
      VStack {
        if imageLoader.image != nil {
          Image(uiImage: imageLoader.image!)
            .resizable()
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
        } else if imageLoader.errorMessage != nil {
          Text(imageLoader.errorMessage!)
            .foregroundColor(.pink)
        } else {
          ZStack {
            Rectangle()
              .frame(maxWidth: .infinity)
              .aspectRatio(1, contentMode: .fit)
              .opacity(0.0)
            ProgressView()
              .frame(maxWidth: .infinity)
          }
        }
      }
      .onAppear {
        DispatchQueue.main.async {
          imageLoader.fetch()
        }
      }
    }
}

class ImageLoader: ObservableObject {
  let url: String?
  
  @Published var image: UIImage? = nil
  @Published var errorMessage: String? = nil
  @Published var isLoading: Bool = false
  
  init(url: String?) {
    self.url = url
  }
  
  func fetch() {
    guard let url = url else { return }
    isLoading = false
    APIService().fetchImage(url) { [weak self] result in
      switch result {
        case .success(let success):
          guard let uiImage = UIImage(data: success) else { return }
          DispatchQueue.main.async {
            self?.image = uiImage
            self?.isLoading = true
          }
        case .failure(_):
          DispatchQueue.main.async {
            self?.image = nil
            self?.errorMessage = "데이터 로드 오류"
            self?.isLoading = true
          }
      }
    }
  }
}

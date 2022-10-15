//
//  ProductCreateView.swift
//  MangoMarket
//
//  Created by RED on 2022/10/15.
//

import SwiftUI

struct ProductCreateView: View {
  @State var title: String = ""
  @State var description: String = ""
  @State var price: String = ""
  @State var discountedPrice: String = ""
  @State var currency: Currency = .KRW
  
  var body: some View {
    Form {
      TextField("제품 이름", text: $title)
      HStack {
        TextField("가격", text: $price)
        Picker("", selection: $currency) {
          ForEach(Currency.allCases, id:\.self) { curreny in
            Text(curreny.rawValue)
          }
        }.pickerStyle(.segmented)
      }
      TextField("할인된 가격", text: $discountedPrice)
      TextField("제품 설명", text: $description)
    }
    
  }
}

struct ProductCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCreateView()
    }
}

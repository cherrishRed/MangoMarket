//
//  ButtonStyle.swift
//  MangoMarket
//
//  Created by RED on 2022/11/02.
//

import SwiftUI

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

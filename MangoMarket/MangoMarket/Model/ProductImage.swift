//
//  ProductImage.swift
//  MangoMarket
//
//  Created by RED on 2022/11/03.
//

import Foundation

struct ProductImage: Codable, Hashable {
  let id: Int?
  let url: String?
  let thumbnailURL: String?
  let issuedAt: String?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case url
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

struct ImageInfo: Encodable, Hashable {
  let fileName: String
  let data: Data
  let type: String
}

struct Vendor: Codable, Hashable {
  let name: String?
  let id: Int?
  let createdAt: String?
  let issuedAt: String?
  
  private enum CodingKeys: String, CodingKey {
    case name
    case id
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

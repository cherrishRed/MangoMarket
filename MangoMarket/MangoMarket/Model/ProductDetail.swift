//
//  ProductDetail.swift
//  MangoMarket
//
//  Created by RED on 2022/09/30.
//

import Foundation

struct ProductDetail: Codable, Hashable {
  let id: Int?
  let vendorID: Int?
  let name: String?
  let thumbnail: URL?
  let currency: Currency?
  let price: Double?
  let description: String?
  let bargainPrice: Double?
  let discountedPrice: Double?
  let stock: Int?
  let createdAt: String?
  let issuedAt: String?
  let imageInfos: [ProductImage]?
  let vendor: Vendor?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case vendorID = "vendor_id"
    case name
    case thumbnail
    case currency
    case price
    case description
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case stock
    case createdAt = "created_at"
    case issuedAt = "issued_at"
    case imageInfos = "images"
    case vendor = "vendors"
  }
}

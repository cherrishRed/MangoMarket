//
//  ProductRequest.swift
//  MangoMarket
//
//  Created by RED on 2022/10/22.
//

import Foundation

struct ProductRequest: Encodable {
  
    var pageNumber: Int?
    var perPages: Int?
    var name: String?
    var description: String?
    var price: Double?
    var currency: Currency?
    var discountedPrice: Double?
    var stock: Int?
    var secret: String?
    var imageInfos: [ImageInfo]?
    var boundary: String? = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case perPages = "items_per_page"
        case discountedPrice = "discounted_price"
        case imageInfos = "images"
        case name, description, price, currency, stock, secret
    }
}

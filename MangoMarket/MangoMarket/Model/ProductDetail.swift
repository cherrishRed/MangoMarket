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

struct ProductImage: Codable, Hashable {
    let id: Int?
    let url: String?
    let thumbnailURL: String?
//    let isSuccess: Bool?
    let issuedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
//        case isSuccess = "succeed"
        case issuedAt = "issued_at"
    }
}

struct ProductRequest: Encodable {
    var pageNumber: Int?
    var perPages: Int?
    var name: String?
    var descriptions: String?
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
        case name, descriptions, price, currency, stock, secret
    }
}

struct ProductEditRequestModel: Encodable {
    var pageNumber: Int?
    var perPages: Int?
    var name: String?
    var descriptions: String?
    var price: Double?
    var currency: Currency?
    var discountedPrice: Double?
    var stock: Int?
    var secret: String?
    var boundary: String? = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case perPages = "items_per_page"
        case discountedPrice = "discounted_price"
        case name, descriptions, price, currency, stock, secret
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

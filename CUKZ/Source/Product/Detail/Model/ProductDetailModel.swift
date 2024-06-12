//
//  ProductDetailModel.swift
//  CUKZ
//
//  Created by 이승민 on 5/10/24.
//

struct ProductDetailModel: Codable {
    let id: Int
    let status, name: String
    let price: Int
    let info, startDate, endDate: String
    let imageUrls: [String]
    let nickname: String
    let likesCount: Int
    let options: [Option]
    let sellerId: Int
    let sellerAccount: String?
    let isLiked, isBuy: Bool
    
    struct Option: Codable {
        let id: Int
        let name: String
        let additionalPrice: Int
    }
}

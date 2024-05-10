//
//  ProductHomeModel.swift
//  CUKZ
//
//  Created by 이승민 on 5/10/24.
//

struct ProductHomeModel: Codable {
    let status: String
    let body: Body
    
    struct Body: Codable {
        let listSize, totalPage, totalElements: Int
        let content: [Content]
        let first, last: Bool
    }
    
    struct Content: Codable {
        let id: Int
        let productName: String
        let price, likesCount: Int
        let imageUrl: String
        let nickname: String
    }
}

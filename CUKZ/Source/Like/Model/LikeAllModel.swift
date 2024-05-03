//
//  LikeAllModel.swift
//  CUKZ
//
//  Created by 이승민 on 4/17/24.
//

// MARK: - Welcome
struct LikeAllModel: Codable {
    let status: String
    let body: Body
    
    struct Body: Codable {
        let listSize, totalPage, totalElements: Int
        let content: [Content]
        let first, last: Bool
    }
    
    struct Content: Codable {
        let status, name: String
        let price: Int
        let imageUrls: [String]
        let nickname: String
        let likesCount: Int
    }
}

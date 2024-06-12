//
//  AllDemandUserRespose.swift
//  CUKZ
//
//  Created by 이승민 on 5/28/24.
//

struct AllDemandUserResponse: Codable {
    let listSize, totalPage, totalElements: Int
    let content: [Content]
    let first, last: Bool
    
    struct Content: Codable {
        let id, productId, memberId: Int
        let email, productName: String
        let price: Int
        let status: String
        let imageUrlList: [String]
        let optionList: [OptionList]
    }
    
    struct OptionList: Codable {
        let optionId, quantity, additionalPrice: Int
        let optionName: String
    }
}

//
//  AllDemandUserRespose.swift
//  CUKZ
//
//  Created by 이승민 on 5/28/24.
//

// MARK: - Welcome
struct AllDemandUserRespose: Codable {
    let listSize, totalPage, totalElements: Int
    let content: [Content]
    let first, last: Bool
    
    struct Content: Codable {
        let id, productId, memberId: Int
        let optionList: [OptionList]
    }
    
    struct OptionList: Codable {
        let optionId, quantity: Int
    }
}

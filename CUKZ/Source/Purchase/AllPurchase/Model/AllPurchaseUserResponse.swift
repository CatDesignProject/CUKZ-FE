//
//  AllPurchaseUserResponse.swift
//  CUKZ
//
//  Created by 이승민 on 6/12/24.
//

struct AllPurchaseUserResponse: Codable {
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let content: [Content]
    let first: Bool
    let last: Bool
    
    struct Content: Codable {
        let id: Int
        let memberId: Int
        let productId: Int
        let productName: String
        let price: Int
        let status: String
        let sellerId: Int
        let sellerNickname: String
        let sellerAccount: String
        let buyerName: String
        let buyerPhone: String
        let recipientName: String
        let recipientPhone: String
        let address: String
        let payStatus: Bool
        let payerName: String
        let refundName: String
        let refundAccount: String
        let totalPrice: Int
        let imageUrlList: [String]
        let optionList: [Option]
    }
    
    struct Option: Codable {
        let optionId: Int
        let optionName: String
        let additionalPrice: Int
        let quantity: Int
    }
}

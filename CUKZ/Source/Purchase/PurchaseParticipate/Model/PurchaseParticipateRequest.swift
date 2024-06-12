//
//  PurchaseParticipateRequest.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

struct PurchaseParticipateRequest: Codable {
    let buyerName, buyerPhone, recipientName, recipientPhone, address, payerName, refundName, refundAccount: String
    let optionList: [OptionList]
    
    struct OptionList: Codable {
        let optionId, quantity: Int
    }
}

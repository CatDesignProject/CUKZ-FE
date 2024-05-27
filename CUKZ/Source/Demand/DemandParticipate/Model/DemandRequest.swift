//
//  DemandRequest.swift
//  CUKZ
//
//  Created by 이승민 on 5/28/24.
//

struct DemandRequest: Codable {
    let email: String
    let optionList: [OptionList]
    
    struct OptionList: Codable {
        let optionId, quantity: Int
    }
}

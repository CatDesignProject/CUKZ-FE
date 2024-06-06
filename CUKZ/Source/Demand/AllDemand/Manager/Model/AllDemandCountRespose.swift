//
//  AllDemandCountRespose.swift
//  CUKZ
//
//  Created by 이승민 on 6/6/24.
//

struct AllDemandCountRespose: Codable {
    let optionId: Int
    let optionName: String
    let additionalPrice, quantity: Int
}

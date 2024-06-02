//
//  LoginResponse.swift
//  CUKZ
//
//  Created by 이승민 on 5/26/24.
//

struct LoginResponse: Codable {
    let memberId: Int
    let nickname, role: String
}

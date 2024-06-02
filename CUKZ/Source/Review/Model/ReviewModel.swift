//
//  ReviewModel.swift
//  CUKZ
//
//  Created by 이승민 on 5/11/24.
//

struct ReviewModel: Codable {
    let nickname: String
    let sellerKindnessCnt, goodNotificationCnt, descriptionMatchCnt, arrivalSatisfactoryCnt: Int
}

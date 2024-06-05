//
//  ReviewNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 5/11/24.
//

import Alamofire

final class ReviewNetworkManager {
    
    static let shared = ReviewNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 리뷰 조회
    func getReview(sellerId: Int,
                   completion: @escaping (ReviewModel?) -> Void) {
        
        AF.request("\(baseURL)/reviews/members/\(sellerId)",
                   method: .get)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ReviewModel.self) { response in
            switch response.result {
            case .success(let result):
                print("리뷰 조회 - 네트워킹 성공")
                completion(result)
            case .failure(let error):
                print("리뷰 조회 - \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - 리뷰 작성
    func postReview(sellerId: Int,
                    productId: Int,
                    sellerKindness: Bool,
                    goodNotification: Bool,
                    arrivalSatisfactory: Bool,
                    descriptionMatch: Bool,
                    completion: @escaping (Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "sellerKindness": sellerKindness,
            "goodNotification": goodNotification,
            "arrivalSatisfactory": arrivalSatisfactory,
            "descriptionMatch": descriptionMatch
        ]
        
        AF.request("\(baseURL)/reviews/member/\(sellerId)/purchaseForm/\(productId)",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .response { response in
            print(parameters)
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

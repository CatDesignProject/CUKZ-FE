//
//  PurchaseNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import Alamofire

final class PurchaseNetworkManager {
    
    static let shared = PurchaseNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 구매하기
    func postPurchase(productId: Int,
                      parameters: PurchaseParticipateRequest,
                      completion: @escaping (Error?) -> Void) {
        
        AF.request("\(baseURL)/products/\(productId)/purchase/members",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

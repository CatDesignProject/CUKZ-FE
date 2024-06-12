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
    
    // MARK: - 내가 구매한 상품 전체 목록 조회
    func getAllPurchaseUser(page: Int,
                            completion: @escaping (Result<AllPurchaseUserResponse, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "page" : page,
            "size": 10
        ]
        
        AF.request("\(baseURL)/members/purchase",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AllPurchaseUserResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

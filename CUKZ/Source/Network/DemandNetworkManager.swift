//
//  DemandNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 5/28/24.
//

import Alamofire

final class DemandNetworkManager {
    
    static let shared = DemandNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    
    // MARK: - 수요조사 참여
    func postDemand(productId: Int,
                    parameters: DemandRequest,
                    completion: @escaping (Error?) -> Void) {
        
        AF.request("\(baseURL)/products/\(productId)/demand/members",
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
    
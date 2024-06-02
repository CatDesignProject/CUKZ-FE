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
                    parameters: DemandParticipateRequest,
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
    
    // MARK: - 내가 참여한 수요조사 전체 목록 조회
    func getAllDemandUser(page: Int, 
                          completion: @escaping (Result<AllDemandUserRespose?, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "page" : page,
            "size": 10
        ]
        
        AF.request("\(baseURL)/members/demand",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AllDemandUserRespose.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 내가 참여한 수요조사 단건 조회
    func getDemandUser(demandId: Int,
                       completion: @escaping (Result<AllDemandUserRespose.Content?, Error>) -> Void) {
        
        AF.request("\(baseURL)/members/demand/\(demandId)",
                   method: .get)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AllDemandUserRespose.Content.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

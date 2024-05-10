//
//  LikeNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 4/17/24.
//

import Alamofire

class LikeNetworkManager {
    
    static let shared = LikeNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 좋아요한 목록 전체 조회
    func getLikeAll(page: Int, 
                    size: Int,
                    completion: @escaping (LikeAllModel?) -> Void) {
        
        // 파라미터
        let parameters: [String: Any] = [
            "page": page,
            "size": size
        ]
        
        // Alamofire 요청
        AF.request("\(baseURL)/members/likes",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: LikeAllModel.self) { response in
            switch response.result {
            case .success(let result):
                print("좋아요한 목록 전체 조회 - 네트워킹 성공")
                completion(result)
            case .failure(let error):
                print("좋아요한 목록 전체 조회 - \(error)")
                completion(nil)
            }
        }
    }
}
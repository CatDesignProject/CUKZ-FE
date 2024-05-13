//
//  UserNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 4/17/24.
//

import Alamofire
import Foundation

class UserNetworkManager {
    
    static let shared = UserNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 아이디 중복체크
    func postDuplicateCheck(username: String,
                            completion: @escaping (Bool?) -> Void) {
        
        let parameters: [String: Any] = [
            "username": username
        ]
        
        AF.request("\(baseURL)/members/verify-username",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let result):
                if let result = result as? Bool {
                    completion(result)
                }
                print("아이디 중복 체크 - 네트워킹 성공")
            case .failure(let error):
                completion(nil)
                print("아이디 중복 체크 - \(error)")
            }
        }
    }
    
    // 로그인
    func postLogin(username: String,
                   password: String,
                   completion: @escaping (String?, [String: Any]?) -> Void) {
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request("\(baseURL)/members/login",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success:
                if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.response?.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    let cookie = cookies.first(where: { $0.name == "JSESSIONID" })
                    completion(cookie?.value, response.value as? [String: Any])
                } else {
                    completion(nil, nil)
                }
            case .failure:
                completion(nil, nil)
            }
        }
    }
}

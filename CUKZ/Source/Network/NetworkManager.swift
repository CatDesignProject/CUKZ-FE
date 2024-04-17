//
//  NetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 4/17/24.
//

import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 회원
    
    // 아이디 중복체크
    func postDuplicateCheck(username: String, completion: @escaping (Bool?) -> Void) {
        
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
            case .success(let value):
                if let json = value as? [String: Any], let body = json["body"] as? Bool {
                    completion(body)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    // 로그인
    func postSignUp(username: String,
                    password: String,
                    completion: @escaping (String?) -> Void) {
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request("\(baseURL)/members/login",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.response?.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    let cookie = cookies.first(where: { $0.name == "JSESSIONID" })
                    completion(cookie?.value)
                } else {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
}

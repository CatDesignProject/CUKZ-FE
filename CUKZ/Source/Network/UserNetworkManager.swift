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
    
    // MARK: - 회원가입
    func postSignUp(username: String,
                    password: String,
                    nickname: String,
                    completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "nickname": nickname
        ]
        
        AF.request("\(baseURL)/members/register",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                completion(true)
                print("회원가입 - 네트워킹 성공")
            case .failure(let error):
                completion(false)
                print("회원가입 - \(error)")
            }
        }
    }
    
    // MARK: - 로그인
    func postLogin(username: String,
                   password: String,
                   completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request("\(baseURL)/members/login",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let result):
                if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.response?.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    let cookie = cookies.first(where: { $0.name == "JSESSIONID" })
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postLogout(completion: @escaping (Error?) -> Void) {
        AF.request("\(baseURL)/members/logout",
                   method: .post)
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
    
    // MARK: - 내 정보 조회
    func getUserInfo(completion: @escaping (Result<UserModel, Error>) -> Void) {
        AF.request("\(baseURL)/members/me",
                   method: .get)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: UserModel.self) { response in
            switch response.result {
            case .success(let result):
                print("내 정보 조회 - 네트워킹 성공")
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 총대 인증
    func postRequestLeader(email: String, 
                           completion: @escaping (Error?) -> Void) {
        
        let parameters: [String : Any] = [
            "email" : email
        ]
        
        AF.request("\(baseURL)/members/verify-email",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
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

//
//  ProductNetworkManager.swift
//  CUKZ
//
//  Created by 이승민 on 5/10/24.
//

import UIKit
import Alamofire

final class ProductNetworkManager {
    
    static let shared = ProductNetworkManager()
    
    private let baseURL = "http://3.35.203.198:8080"
    
    private init() {}
    
    // MARK: - 상품 목록 전체 조회
    func getProductAll(page: Int,
                       completion: @escaping (ProductHomeModel?) -> Void) {
        
        // 파라미터
        let parameters: [String: Any] = [
            "page": page
        ]
        
        // Alamofire 요청
        AF.request("\(baseURL)/products/paging",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProductHomeModel.self) { response in
            switch response.result {
            case .success(let result):
                print("상품 목록 전체 조회 - 네트워킹 성공")
                completion(result)
            case .failure(let error):
                print("상품 목록 전체 조회 - \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - 상품 검색
    func getProductSearch(keyword: String,
                          page: Int,
                          completion: @escaping (ProductHomeModel?, Error?) -> Void) {
        
        // 파라미터
        let parameters: [String: Any] = [
            "keyword" : keyword,
            "page": page
        ]
        
        // Alamofire 요청
        AF.request("\(baseURL)/products/search",
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProductHomeModel.self) { response in
            switch response.result {
            case .success(let result):
                print("상품 검색 - 네트워킹 성공")
                completion(result, nil)
            case .failure(let error):
                print("상품 검색 - \(error)")
                completion(nil, error)
            }
        }
    }
    
    // MARK: - 상품 상세보기
    func getProductDetail(productId: Int, 
                          completion: @escaping (ProductDetailModel?) -> Void) {
        
        AF.request("\(baseURL)/products/\(productId)",
                   method: .get,
                   encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProductDetailModel.self) { response in
            switch response.result {
            case .success(let result):
                print("상품 상세보기 - 네트워킹 성공")
                completion(result)
            case .failure(let error):
                print("상품 상세보기 - \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - 이미지 업로드
    func uploadImage(images: [UIImage]) {
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (index, image) in images.enumerated() {
                if let jpegData = image.jpegData(compressionQuality: 0.2) {
                    multipartFormData.append(jpegData,
                                             withName: "files",
                                             fileName: "image\(index).jpeg",
                                             mimeType: "image/jpeg")
                }
            }
        }, to: "\(baseURL)/products/image-upload", method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("\(response)")
                print("이미지 업로드 성공")
            case .failure:
                print("이미지 업로드 실패")
            }
        }
    }
}

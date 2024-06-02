//
//  UploadProductRequest.swift
//  CUKZ
//
//  Created by 이승민 on 5/25/24.
//

struct UploadProductRequest: Codable {
    let name: String
    let price: Int
    let sellerAccount: String
    let status: String
    let startDate: String
    let endDate: String
    let info: String
    let productImageIds: [Int]
    let options: [Options]
    
    struct Options: Codable {
        let name: String
        let additionalPrice: Int
    }
}

extension UploadProductRequest.Options { // 상품 수정할 때
    init(from option: ProductDetailModel.Option) {
        self.name = option.name
        self.additionalPrice = option.additionalPrice
    }
}

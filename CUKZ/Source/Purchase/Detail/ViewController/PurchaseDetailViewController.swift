//
//  PurchaseDetailViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class PurchaseDetailViewController: UIViewController {
    // MARK: - Properties
    private var isBookmark = false
    
    private let purchaseDetailView = PurchaseDetailView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseDetailView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupButton()
    }
    
    private func prepare() {
        
    }
    
    private func setupButton() {
        purchaseDetailView.purchaseDetailBottomView.bookmarkButton.addTarget(nil, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        purchaseDetailView.purchaseDetailBottomView.buyButton.addTarget(nil, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
    
    @objc func bookmarkButtonTapped() {
        isBookmark.toggle()
        
        let systemName = isBookmark ? "bookmark" : "bookmark.fill"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        
        purchaseDetailView.purchaseDetailBottomView.bookmarkButton.setImage(image, for: .normal)
    }
    
    @objc func buyButtonTapped() {
        print("구매하기 버튼 눌림")
    }
    
}

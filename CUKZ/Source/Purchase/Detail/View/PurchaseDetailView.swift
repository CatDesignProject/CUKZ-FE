//
//  PurchaseDetailView.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class PurchaseDetailView: UIView {
    // MARK: - View
    let purchaseDetailBottomView = PurchaseDetailBottomView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        self.addSubviews([purchaseDetailBottomView])
    }
    
    private func configureConstraints() {
        purchaseDetailBottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(110)
        }
    }
}

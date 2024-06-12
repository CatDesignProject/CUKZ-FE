//
//  PurchaseParticipateOptionView.swift
//  CUKZ
//
//  Created by 이승민 on 6/11/24.
//

import UIKit

final class PurchaseParticipateOptionView: UIView {
    // MARK: - View
    private let quantityLabel = UILabel().then {
        $0.text = "수량"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let tableView = UITableView().then {
        $0.separatorInset.left = 20
        $0.separatorInset.right = 20
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("개인정보 입력", for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
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
        self.addSubviews([
            quantityLabel,
            tableView,
            completeButton
        ])
    }
    
    private func configureConstraints() {
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}


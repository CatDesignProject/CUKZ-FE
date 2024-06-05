//
//  PurchaseParticipateView.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class PurchaseParticipateView: UIView {
    // MARK: - View
    let tableView = UITableView().then {
        $0.keyboardDismissMode = .onDrag // 스크롤 할 때 키보드 내리기
        $0.separatorInset.left = 20
        $0.separatorInset.right = 20
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("구매하기", for: .normal)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
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
            tableView,
            completeButton
        ])
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
